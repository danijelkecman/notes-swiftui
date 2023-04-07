const { default: mongoose } = require("mongoose");

mongoose.connect('mongodb://127.0.0.1:27017/notes-api', {
        useNewUrlParser: true
    })
    .then((res) => {
    console.log(
        'Connected to Distribution API Database - Initial Connection'
    );
    })
    .catch((err) => {
    console.log(
        `Initial Distribution API Database connection error occured -`,
        err
    );
    });