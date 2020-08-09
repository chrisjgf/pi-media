const express = require("express");
const { exec } = require("child_process");
const app = express();
const Client = require("ssh2-sftp-client");
var bodyParser = require("body-parser");
const fs = require("fs");
app.use(bodyParser.json()); // support json encoded bodies
app.use(bodyParser.urlencoded({ extended: true })); // support encoded bodies

// TODO: - Temporary fix to handle multiple connections
const sftpDownload = new Client("download-client");
const sftpBasic = new Client("basic-client");
//

const blacklistFiles = ["filezilla", "", "vpn", "watch", ".htaccess"];
const defaultLocalDir = "./downloads/";
const defaultRemoteDir = "/"; // enter default directory here

const config = {
  host: `${process.env.HOST}`,
  username: `${process.env.USERNAME}`,
  password: `${process.env.PASS}`,
};

console.log("Authenticating with", process.env.HOST, process.env.USERNAME, process.env.PASS)

const playFile = async (req, res) => {
  const { filename } = req.body;

  exec(`vlc -f ${defaultLocalDir}${filename}`, (error, stdout) => {
    console.log(`playing ${defaultLocalDir}${filename}`);
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

  sftpDownload
    .connect(config)
    .then(() => {
      res.send(true);
      return sftpDownload.get(remotePath, dst);
    })
    .then((data) => {
      sftpDownload.end();
    })
    .catch((err) => {
      console.log(`Error: ${err.message}`);
      res.send(false);
    });
};

const getFiles = async (res) => {
  const filesInLocalDirectory = fs.readdirSync(defaultLocalDir);
  const getStatus = (file) => {
    const foundFile = filesInLocalDirectory.find((name) => name === file.name);
    if (!!foundFile) {
      const localFile = fs.statSync(`${defaultLocalDir}${foundFile}`);
      if (file.size === localFile["size"]) {
        return "COMPLETE";
      } else {
        return "PROGRESS";
      }
    }
    return "AVAILABLE";
  };

  sftpBasic
    .connect(config)
    .then(() => {
      return sftpBasic.list(defaultRemoteDir);
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
        status: getStatus(file),
      }));
      res.send(mappedFiles);
      return sftpBasic.end();
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
  sftpDownload.end();
});

app.listen(3000, () => console.log("Listening on port 3000!"));
