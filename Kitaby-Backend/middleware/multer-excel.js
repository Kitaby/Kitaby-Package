const multer = require('multer');

const MIME_TYPES = {
    'application/msexcel':'xlsx'
};

const storage = multer.diskStorage({
  destination: (req, file, callback) => {
    callback(null, 'excel');
  },
  filename: (req, file, callback) => {
    const extension = MIME_TYPES[file.mimetype];
    if (extension){
      callback(null, req.auth.bibId + '.xlsx');
    }
  }
});

module.exports = multer({storage: storage}).single('file');