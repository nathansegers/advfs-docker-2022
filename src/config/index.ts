// import { config } from 'dotenv';
// config({ path: `.env.${process.env.NODE_ENV || 'development'}.local` });

export const { NODE_ENV, PORT, LOG_DIR } = process.env;

// Read service account json file
export const serviceAccount = require('./service-account.json');
