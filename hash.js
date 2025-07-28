import bcrypt from 'bcryptjs';

const password = "123";  // Ο απλός κωδικός που θέλεις
const hash = bcrypt.hashSync(password, 10); // 10 γύροι κρυπτογράφησης
console.log("Hashed password:", hash);

const hash2 = await bcrypt.hash('123456', 10);
console.log(hash2);