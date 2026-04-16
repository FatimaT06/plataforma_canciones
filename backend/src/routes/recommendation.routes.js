const router = require("express").Router();
const { getRecommendations } = require("../controllers/recommendation.controller");

router.get("/:user", getRecommendations);

module.exports = router;
