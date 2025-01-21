const express = require("express");
const bodyParser = require("body-parser");
const service = require("./services/service");

const app = express();

app.use(bodyParser.json());

// health check
app.get("/", (req, res) => {
  res.status(200).send("Service App Health: OK");
});

app.post("/service", service.createService);

app.put("/service/:id", service.updateService);

app.delete("/service/:id", service.deleteService);

app.get("/service/:id", service.getService);

app.get("/services", service.getAllServices);

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Service App is running at http://localhost:${PORT}/`);
});
