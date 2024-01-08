const fs = require('fs');


// Read the contents of the two JSON files
const en_data_raw = fs.readFileSync('src/i18n/transifex_input.json', 'utf8');
var trans_raw = fs.readFileSync(`src/i18n/messages/${process.env.EDX_LANG}.json`, 'utf8');

const PATH = `../${process.env.LOCALE_FOLDER}/mfe/${process.env.APP}/${process.env.EDX_LANG}.json`

if (fs.existsSync(PATH)){
    trans_raw = fs.readFileSync(PATH, 'utf8');
} 

// Parse the JSON data from both files
const en_data = JSON.parse(en_data_raw);
const trans = JSON.parse(trans_raw);

// Iterate over the keys in the first file and merge the values
const mergedData = { ...en_data };
const untranslated = {};
for (const key in en_data) {
    
    if (trans.hasOwnProperty(key)) {
        mergedData[key] = trans[key];
        // Store untranslated strings
        if(en_data[key] === trans[key]){
            untranslated[key] = en_data[key];
        }
    } else {
        // Store missing strings as untranslated as well
        untranslated[key] = en_data[key];
    }
}

// Write the data to a new JSON files
const mergedFileContent = JSON.stringify(mergedData, null, 2);
const untransFileContent = JSON.stringify(untranslated, null, 2);
fs.writeFileSync('merged_file.json', mergedFileContent);
fs.writeFileSync('untrans_file.json', untransFileContent);

console.log('Merged data saved to "merged_file.json"');
console.log('And untranslated strings saved to "untrans_file.json"');
