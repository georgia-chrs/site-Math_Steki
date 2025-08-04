// Δυναμικός Υπολογιστής Μορίων και Σχολών
class MoriaCalculator {
    constructor() {
        this.data = {
            lykeio: '',
            pedio: '',
            vathmoi: {},
            eidika: []
        };
        this.scholesData = null;
        this.systemConfig = null;
    }

    // Φόρτωση ρυθμίσεων συστήματος
    async loadSystemConfig() {
        try {
            const response = await fetch('../data/system-config.json');
            if (!response.ok) {
                throw new Error('Σφάλμα φόρτωσης ρυθμίσεων συστήματος');
            }
            this.systemConfig = await response.json();
            return this.systemConfig;
        } catch (error) {
            console.error('Σφάλμα:', error);
            return null;
        }
    }

    // Λήψη διαθέσιμων πεδίων για συγκεκριμένο λύκειο
    getAvailablePedia(lykeioId) {
        if (!this.systemConfig) return [];
        
        const lykeio = this.systemConfig.lykeiaTypes.find(l => l.id === lykeioId);
        if (!lykeio) return [];
        
        return lykeio.pedia.map(pedioId => ({
            id: pedioId,
            name: this.systemConfig.pedia[pedioId]?.name || pedioId
        }));
    }

    // Λήψη μαθημάτων για συγκεκριμένο πεδίο
    getMathimataForPedio(pedioId) {
        if (!this.systemConfig || !this.systemConfig.pedia[pedioId]) return [];
        
        return this.systemConfig.pedia[pedioId].mathimata;
    }

    // Λήψη ειδικών μαθημάτων για συγκεκριμένο πεδίο
    getEidikaMathimataForPedio(pedioId) {
        if (!this.systemConfig || !this.systemConfig.pedia[pedioId]) return [];
        
        return this.systemConfig.pedia[pedioId].eidikaMathimata;
    }

    // Φόρτωση δεδομένων σχολών βάσει πεδίου
    async loadScholesData(pedioId) {
        try {
            if (!this.systemConfig || !this.systemConfig.pedia[pedioId]) {
                throw new Error('Άγνωστο πεδίο');
            }

            const fileName = this.systemConfig.pedia[pedioId].dataFile;
            const response = await fetch(`../data/${fileName}`);
            if (!response.ok) {
                throw new Error('Σφάλμα φόρτωσης δεδομένων σχολών');
            }
            this.scholesData = await response.json();
            return this.scholesData;
        } catch (error) {
            console.error('Σφάλμα:', error);
            return null;
        }
    }

    // Υπολογισμός μορίων για μια σχολή
    calculateMoria(scholi, vathmoi, eidika) {
        let totalMoria = 0;
        let totalSyntelestis = 0;

        // Υπολογισμός κύριων μαθημάτων
        scholi.mathimata.forEach((mathima, index) => {
            const vathmosKey = this.getMathimaKey(mathima);
            const vathmos = vathmoi[vathmosKey] || 0;
            const syntelestis = scholi.syntelesties[index];
            totalMoria += vathmos * syntelestis * 100;
            totalSyntelestis += syntelestis;
        });

        // Προσθήκη ειδικών μαθημάτων
        eidika.forEach(eidiko => {
            if (eidiko.mathima && eidiko.vathmos && scholi.eidika.includes(eidiko.mathima)) {
                totalMoria += eidiko.vathmos * 0.1 * 100; // 10% συντελεστής για ειδικά
            }
        });

        return Math.round(totalMoria);
    }

    // Μετατροπή ονόματος μαθήματος σε κλειδί
    getMathimaKey(mathima) {
        const mapping = {
            'Νεοελληνική Γλώσσα': 'glossa',
            'Αρχαία Ελληνικά': 'archaia',
            'Ιστορία': 'istoria',
            'Λατινικά': 'latina',
            'Μαθηματικά': 'mathimatika',
            'Φυσική': 'fysiki',
            'Χημεία': 'chimeia',
            'Βιολογία': 'viologia',
            'Στατιστική': 'statistiki',
            'Οικονομικά': 'oikonomika',
            'Πληροφορική': 'plirofiriki',
            'Τεχνολογία': 'technologia',
            'Ειδικότητα': 'eidikotita',
            'Διοίκηση': 'dioikisi',
            'Λογιστικά': 'logistika',
            'Γεωγραφία': 'geografia',
            'Ξένες Γλώσσες': 'xenes_glosses',
            'Μηχανολογία': 'michanologia',
            'Ηλεκτρολογία': 'ilektrologika',
            'Αυτοματισμοί': 'automatismoi'
        };
        return mapping[mathima] || mathima.toLowerCase().replace(/\s+/g, '_');
    }

    // Εύρεση κατάλληλων σχολών
    findSuitableScholes(vathmoi, eidika) {
        if (!this.scholesData) return [];

        const results = [];
        
        this.scholesData.scholes.forEach(scholi => {
            const moria = this.calculateMoria(scholi, vathmoi, eidika);
            
            if (moria >= scholi.vasi) {
                results.push({
                    ...scholi,
                    calculatedMoria: moria,
                    difference: moria - scholi.vasi
                });
            }
        });

        // Ταξινόμηση κατά φθίνουσα σειρά βάσης
        return results.sort((a, b) => b.vasi - a.vasi);
    }

    // Εμφάνιση αποτελεσμάτων στο βήμα 5
    displayResults(vathmoi, eidika) {
        const suitableScholes = this.findSuitableScholes(vathmoi, eidika);
        const resultsContainer = document.querySelector('#step5-results');
        const excelContainer = document.querySelector('#excel-export-container');
        
        if (!resultsContainer) {
            console.error('Δεν βρέθηκε το container των αποτελεσμάτων');
            return;
        }

        if (suitableScholes.length === 0) {
            resultsContainer.innerHTML = `
                <div class="no-results">
                    <h3>Δυστυχώς δεν βρέθηκαν κατάλληλες σχολές</h3>
                    <p>Προσπαθήστε να βελτιώσετε τους βαθμούς σας ή να προσθέσετε ειδικά μαθήματα.</p>
                </div>
            `;
            // Απόκρυψη του Excel export button
            if (excelContainer) {
                excelContainer.style.display = 'none';
            }
            return;
        }

        // Αποθήκευση αποτελεσμάτων για Excel export
        this.lastResults = {
            vathmoi: vathmoi,
            eidika: eidika,
            suitableScholes: suitableScholes
        };

        let html = `
            <div class="results-header">
                <h3>Κατάλληλες Σχολές για εσάς:</h3>
                <p>Βρέθηκαν ${suitableScholes.length} σχολές που μπορείτε να περάσετε!</p>
            </div>
            <div class="scholes-list">
        `;

        suitableScholes.forEach((scholi, index) => {
            html += `
                <div class="scholi-item ${index < 3 ? 'top-choice' : ''}">
                    <div class="scholi-header">
                        <h4>${scholi.name}</h4>
                        <span class="rank">#${index + 1}</span>
                    </div>
                    <div class="scholi-details">
                        <div class="moria-info">
                            <span class="label">Τα μόρια σας:</span>
                            <span class="value">${scholi.calculatedMoria.toLocaleString()}</span>
                        </div>
                        <div class="vasi-info">
                            <span class="label">Βάση σχολής:</span>
                            <span class="value">${scholi.vasi.toLocaleString()}</span>
                        </div>
                        <div class="difference-info">
                            <span class="label">Διαφορά:</span>
                            <span class="value positive">+${scholi.difference.toLocaleString()}</span>
                        </div>
                    </div>
                </div>
            `;
        });

        html += '</div>';
        resultsContainer.innerHTML = html;

        // Εμφάνιση του Excel export button
        if (excelContainer) {
            excelContainer.style.display = 'block';
            
            // Προσθήκη event listener αν δεν υπάρχει
            const exportBtn = document.getElementById('export-excel-btn');
            if (exportBtn && !exportBtn.hasAttribute('data-listener-added')) {
                exportBtn.addEventListener('click', () => this.exportToExcel());
                exportBtn.setAttribute('data-listener-added', 'true');
            }
        }
    }

    // Export αποτελεσμάτων ως Excel
    exportToExcel() {
        try {
            console.log('Έναρξη Excel export...');
            
            if (!window.XLSX) {
                alert('Η βιβλιοθήκη XLSX δεν έχει φορτωθεί. Παρακαλώ ανανεώστε τη σελίδα και δοκιμάστε ξανά.');
                return;
            }

            if (!this.lastResults || !this.lastResults.suitableScholes) {
                alert('Δεν υπάρχουν αποτελέσματα για export.');
                return;
            }

            const { vathmoi, eidika, suitableScholes } = this.lastResults;

            // Δημιουργία δεδομένων για Excel
            const excelData = [];
            
            // Header
            excelData.push([
                'Κατάταξη',
                'Όνομα Σχολής',
                'Τα Μόρια Σας',
                'Βάση Σχολής',
                'Διαφορά',
                'Ποσοστό Υπέρβασης (%)'
            ]);

            // Δεδομένα σχολών
            suitableScholes.forEach((scholi, index) => {
                const pososto = ((scholi.difference / scholi.vasi) * 100).toFixed(2);
                excelData.push([
                    index + 1,
                    scholi.name,
                    scholi.calculatedMoria,
                    scholi.vasi,
                    scholi.difference,
                    pososto
                ]);
            });

            // Προσθήκη κενής γραμμής και στοιχείων χρήστη
            excelData.push([]);
            excelData.push(['ΣΤΟΙΧΕΙΑ ΧΡΗΣΤΗ']);
            excelData.push([]);
            
            // Βαθμοί
            excelData.push(['ΒΑΘΜΟΙ ΜΑΘΗΜΑΤΩΝ']);
            Object.entries(vathmoi).forEach(([mathima, vathmos]) => {
                excelData.push([mathima, vathmos]);
            });

            // Ειδικά μαθήματα
            if (eidika && eidika.length > 0) {
                excelData.push([]);
                excelData.push(['ΕΙΔΙΚΑ ΜΑΘΗΜΑΤΑ']);
                eidika.forEach(eidiko => {
                    excelData.push([eidiko.mathima, eidiko.vathmos]);
                });
            }

            // Δημιουργία workbook
            const wb = XLSX.utils.book_new();
            const ws = XLSX.utils.aoa_to_sheet(excelData);

            // Formatting του worksheet
            const range = XLSX.utils.decode_range(ws['!ref']);
            
            // Styling για headers
            for (let C = range.s.c; C <= range.e.c; ++C) {
                const address = XLSX.utils.encode_cell({ r: 0, c: C });
                if (!ws[address]) continue;
                ws[address].s = {
                    font: { bold: true },
                    fill: { fgColor: { rgb: "5b3c2a" } },
                    alignment: { horizontal: "center" }
                };
            }

            // Προσθήκη του worksheet στο workbook
            XLSX.utils.book_append_sheet(wb, ws, "Αποτελέσματα Μορίων");

            // Δημιουργία filename με timestamp
            const now = new Date();
            const timestamp = now.toISOString().slice(0, 19).replace(/[:-]/g, '');
            const filename = `Αποτελεσματα_Μοριων_${timestamp}.xlsx`;

            console.log('Δημιουργία Excel αρχείου:', filename);

            // Export του αρχείου
            XLSX.writeFile(wb, filename);

            console.log('Excel export ολοκληρώθηκε επιτυχώς');

        } catch (error) {
            console.error('Σφάλμα κατά το Excel export:', error);
            alert('Σφάλμα κατά το export. Παρακαλώ δοκιμάστε ξανά.');
        }
    }
}

// Δημιουργία instance του calculator
const moriaCalculator = new MoriaCalculator();

// Export για χρήση σε άλλα αρχεία
window.MoriaCalculator = MoriaCalculator;
window.moriaCalculator = moriaCalculator;
