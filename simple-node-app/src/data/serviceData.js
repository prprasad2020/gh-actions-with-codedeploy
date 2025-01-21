const { v4: uuidv4 } = require('uuid');

class Service {
  constructor(name, language, version) {
    if (!name || !language || !version) {
      throw new Error("Name, language, and version are required");
    }
    if (typeof name !== "string" || typeof language !== "string" || typeof version !== "string") {
      throw new Error("Name, language, and version must be strings");
    }

    this.id = uuidv4();
    this.name = name;
    this.language = language;
    this.version = version;
  }
}

module.exports = Service;
