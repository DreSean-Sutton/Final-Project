require('dotenv/config');
const express = require('express');
const pg = require('pg');
const ClientError = require('./client-error');
const errorMiddleware = require('./error-middleware');
const swaggerUi = require('swagger-ui-express');
const YAML = require('yamljs');

const db = new pg.Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false
  }
});

const app = express();
const swaggerDocument = YAML.load('./openapi.yml');

app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));

app.get('/api/fighters', (req, res, next) => {
  const queryStr = req.query;
  const queryKey = Object.keys(queryStr)
  if (queryStr.fighter) {
    const sql = `
    SELECT
      "fighterId", fighter,
      "rosterId", "displayName"
    FROM
      fighters
    WHERE
      fighter=$1
    `;
    const params = [queryStr.fighter];
    if (/\d/g.test(params)) {
      throw new ClientError(400, `fighter name can't have a number`);
    }
    return db.query(sql, params)
    .then(result => {
    if (result.rows.length === 0)
    throw new ClientError(404, `${queryKey} named ${params} doesn't exist in the database`)
      res.status(200).send(result.rows[0]);
    })
    .catch(err => next(err));
  }
  if (queryStr.fighterId) {
    const sql = `
    SELECT
      "fighterId", fighter,
      "rosterId", "displayName"
    FROM
      fighters
    WHERE
      "fighterId"=$1
    `;
    const params = [queryStr.fighterId];
    if (/[A-Za-z]/gi.test(params)) {
      throw new ClientError(400, `fighterId can't contain any letters`);
    }
    return db.query(sql, params)
      .then(result => {
      if (result.rows.length === 0)
        throw new ClientError(404, `${queryKey} ${params} doesn't exist in the database`)
        res.status(200).send(result.rows[0]);
      })
      .catch(err => next(err));
  }
  if (queryStr.rosterId) {
    const sql = `
    SELECT
      "fighterId", fighter,
      "rosterId", "displayName"
    FROM
      fighters
    WHERE
      "rosterId"=$1
    `;
    const params = [queryStr.rosterId];
    if (/[A-Za-z]/gi.test(params)) {
      throw new ClientError(400, `rosterId can't contain any letters`);
    }
    return db.query(sql, params)
      .then(result => {
      if (result.rows.length === 0)
        throw new ClientError(404, `${queryKey} ${params} doesn't exist in the database`)
        res.status(200).send(result.rows[0]);
      })
      .catch(err => next(err));
  }
  if (queryKey.length > 0) {
    throw new ClientError(400, `${queryKey} is not a valid query key`)
  }
  const sql = `
    SELECT
      "fighterId", fighter,
      "rosterId", "displayName"
    FROM
      fighters
    `;
  return db.query(sql)
    .then(result => {
      res.status(200).send(result.rows);
    })
    .catch(err => next(err));
});

app.get('/api/fighters/data', (req, res, next) => {
  const sql = `
  SELECT
    "activeFrames", "damage", "displayName",
    fighter, "fighterId", "moveType",
    "name", "rosterId",
    "totalFrames"
  FROM
    fighters
  JOIN "moves" USING ("fighterId")
  JOIN "hitboxes" USING ("moveId")
  ORDER BY "moveId"
  `;
  return db.query(sql)
  .then(result => res.status(200).send(result.rows))
  .catch(err => next(err));
});

app.use(errorMiddleware)
app.listen(process.env.PORT, () => {
  // eslint-disable-next-line no-console
  console.log(`express server listening on port ${process.env.PORT}`);
});
