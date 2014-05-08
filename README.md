k-stack
=======

Starting point for website/webapp/webwhateve.

Dev:
```
npm install
bower install
nodemon app.coffee
```

Prod:
```
grunt build
NODE_ENV=production forever -c coffee app.coffee
```
