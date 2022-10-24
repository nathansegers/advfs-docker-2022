import { serviceAccount } from '../config';
import { NextFunction, Request, Response } from 'express';

class IndexController {
  public index = (req: Request, res: Response, next: NextFunction): void => {
    try {
      res.sendStatus(200);
    } catch (error) {
      next(error);
    }
  };

  public foo = (req: Request, res: Response, next: NextFunction): void => {
    try {
      res.status(200).send({
        message: 'Hello World (and give me some Bars please)',
      });
    } catch (error) {
      next(error);
    }
  };

  public secret = (req: Request, res: Response, next: NextFunction): void => {
    try {
      res.status(200).send(serviceAccount);
    } catch (error) {
      next(error);
    }
  };
}

export default IndexController;
