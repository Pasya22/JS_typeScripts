
// menghitung kata menggunakan metode camel case 
let str = 'saveChangeInTheWord';


if(str[0] === str[0].toLowerCase()){
    count = 1;
}
else
{
     count = 0;
}
let words = str.match(/[A-Z]/g);
let wordCount = words.length + count;
console.log(wordCount); 










