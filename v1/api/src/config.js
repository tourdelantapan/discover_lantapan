require("dotenv").config();
const env = process.env;

module.exports = {
  env: {
    dev: process.env.NODE_ENV !== "production",
  },
  baseUrl:
    process.env.NODE_ENV === "production"
      ? "https://visitour.app"
      : "http://13.214.25.127",
  mongodb: {
    ip: env.MONGODB_IP,
    port: env.MONGODB_PORT,
    db: env.MONGODB_STAGING_DB_NAME,
    username: env.MONGODB_USERNAME,
    password: env.MONGODB_PASSWORD,
    clusterUrl: env.MONGODB_STAGING_CLUSTER_URL,
  },
  crypto: {
    privateKey: env.CRYPTO_PRIVATE_KEY,
    tokenExpiry: 1 * 30 * 1000 * 60, //1 hour
  },
};
