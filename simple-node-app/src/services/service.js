const Service = require("../data/serviceData");

const serviceData = [];

async function createService(req, res) {
  try {
    const service = new Service(req.body.name, req.body.language, req.body.version);
    serviceData.push(service);
    res.status(201).send(service);
  } catch (err) {
    res.status(500).send(err);
  }
}

async function updateService(req, res) {
  try {
    const index = serviceData.findIndex((service) => service.id === req.params.id);
    if (index !== -1) {
      serviceData[index] = {...serviceData[index], ...req.body};
      res.send(serviceData[index]);
    } else {
      res.status(404).send("Service not found");
    }
  } catch (err) {
    res.status(500).send(err);
  }
}

async function deleteService(req, res) {
  try {
    const index = serviceData.findIndex((service) => service.id === req.params.id);
    if (index !== -1) {
      serviceData.splice(index, 1);
      res.send("Service deleted");
    } else {
      res.status(404).send("Service not found");
    }
  } catch (err) {
    res.status(500).send(err);
  }
}

async function getService(req, res) {
  try {
    const index = serviceData.findIndex((service) => service.id === req.params.id);
    if (index !== -1) {
      res.send(serviceData[index]);
    } else {
      res.status(404).send("Service not found");
    }
  } catch (err) {
    res.status(500).send(err);
  }
}

function getAllServices(req, res) {
  try {
    const services = serviceData;
    if (!services || services.length === 0) {
      res.status(404).send("Services not found");
    } else {
      res.send(services);
    }
  } catch (err) {
    res.status(500).send(err);
  }
}

module.exports = {
  createService,
  updateService,
  deleteService,
  getService,
  getAllServices,
};
