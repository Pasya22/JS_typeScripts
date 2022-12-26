// menampilkan hari senin-minggu

let hari = new Date();
let hariIni = hari.getDay();

let namaHari = ["Minggu", "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"];
for (let i = 0; i < namaHari.length; i++) {
    if (hariIni === i) {
        console.log("hari ini adalah " + namaHari[i]);
        break;
    }
}

// if (hariIni === 0) {
//     console.log("minggu");
// }
// else if(hariIni === 6)
// {
//     console.log("sabtu");
// }
// --------------------------------------------------------------------------------------------

// menampilkan angka genap 
for ( let genap = 0; genap <= 100; genap++)
if (genap % 2 == 0) {
    console.log(genap);
}

// -------------------------------------------------------------------------------
// menampilkan angka ganjil 
for (let ganjil = 1; ganjil <= 100; ganjil++)
if (ganjil % 2 == 1) {
    console.log(ganjil);
}

// ===============================================================================
// menampilkan huruf kapital 

let kapital = " " ;
for (let i = 65; i <= 90; i++) {
    kapital +=  String.fromCharCode(i) + ' ';
  }
console.log(kapital);

// ==============================================================================
// menampilkan huruf kecil 
let kecil = " " ;
for (let i = 97; i <= 122; i++) {
    kecil +=  String.fromCharCode(i) + ' ';
  }
console.log(kecil);
