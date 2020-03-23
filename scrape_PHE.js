// scrapes a given url 
// Script stolen from: https://www.robert-hickman.eu/post/dynamic_web_scraping/

// create a webpage object
var page = require('webpage').create(),
  system = require('system')

// the url provided as an argument
 address = system.args[1];
// address = "https://www.arcgis.com/apps/opsdashboard/index.html#/f94c3c90da5b4e9f9a0b19484dd4bb14";

// include the File System module for writing to files
var fs = require('fs');

// specify source and path to output file
// we'll just overwirte iteratively to a page in the same directory
var path = 'phe-web-scrape.html'

page.open(address, function (status) {
    if (status !== 'success') {
        console.log('Unable to load the address!');
        phantom.exit();
    } else {
        window.setTimeout(function () {
           // page.render(address);
           var content = page.content;
           fs.write(path,content,'w');
           phantom.exit();
        }, 5000);
    }
});