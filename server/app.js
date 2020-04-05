const express = require("express");
const { exec } = require("child_process");
const app = express();
var bodyParser = require("body-parser");
const Client = require("ssh2-sftp-client");
const fs = require("fs");
app.use(bodyParser.json()); // support json encoded bodies
app.use(bodyParser.urlencoded({ extended: true })); // support encoded bodies

const sftp = new Client("example-client");
const blacklistFiles = ["filezilla", "", "vpn", "watch", ".htaccess"];

const config = {};

const playFile = async (req, res) => {
  const { filename } = req.body;

  exec(`vlc -f ${defaultLocalDir}${filename}`, (error, stdout) => {
    if (error) {
      console.log(`error: ${error.message}`);
      res.send(false);
      return;
    }
    res.send(true);
  });
};

const deleteFile = async (req, res) => {
  const { filename } = req.body;

  fs.unlink(`${defaultLocalDir}${filename}`, (err) => {
    if (err) {
      console.log("deletion error", filename);
      res.send(false);
      return;
    }
    console.log("deleted", filename);
    res.send(true);
  });
};

const downloadFile = async (req, res) => {
  const { filename } = req.body;

  let remotePath = `${defaultRemoteDir}${filename}`;
  let dst = fs.createWriteStream(`${defaultLocalDir}${filename}`);

  sftp
    .connect(config)
    .then(() => {
      return sftp.get(remotePath, dst);
    })
    .then((data) => {
      sftp.end();
      res.send(true);
    })
    .catch((err) => {
      console.log(`Error: ${err.message}`);
      res.send(false);
    });
};

const getFiles = async (res) => {
  const filesInLocalDirectory = fs.readdirSync(defaultLocalDir);
  const checkDownloadStatus = (_name) => {
    return !!filesInLocalDirectory.find((name) => name === _name);
  };

  sftp
    .connect(config)
    .then(() => {
      return sftp.list(defaultRemoteDir);
    })
    .then((data) => {
      const filteredFiles = data.filter(
        (f) => !blacklistFiles.find((e) => f.name === e)
      );
      const sortedFiles = filteredFiles.sort((a, b) =>
        a.modifyTime < b.modifyTime ? 1 : -1
      );
      const mappedFiles = sortedFiles.map((file) => ({
        name: file.name,
        size: file.size,
        downloaded: checkDownloadStatus(file.name),
      }));
      res.send(mappedFiles);
      return sftp.end();
    })
    .catch((err) => {
      console.log(`Error: ${err.message}`);
    });
};

// Routes
app.get("/files/list", function (req, res) {
  console.log("/files/list");
  getFiles(res);
});

// Post
app.post("/files/download", function (req, res) {
  console.log("/files/download");
  downloadFile(req, res);
});

app.post("/files/delete", async (req, res) => {
  console.log("/files/delete");
  deleteFile(req, res);
});

app.post("/files/play", function (req, res) {
  console.log("/files/play");
  playFile(req, res);
});

app.post("/files/cancel", async (req, res) => {
  console.log("/files/cancel");
  res.send(true);
  sftp.end();
});

app.listen(8080, () => console.log("Listening on port 8080!"));
