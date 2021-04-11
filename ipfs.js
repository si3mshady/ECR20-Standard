const IPFS = require('ipfs-mini');

ipfs = new IPFS({host: 'ipfs.infura.io', port: 5001, protocol:'https'});

const data = 'Saturday Afternoon'

// using infur public gateway 

// can save data on ipfs network interface
// add the data, the hash provided will be the location of the file 
// closet to local computer 
ipfs.add(data, (err, hash) => {
    if (!err) {
        console.log('https://ipfs.infura.io/ipfs/' +  hash)
    }
})