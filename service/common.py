import conf
import flask
import os

app = flask.Flask(__name__)
app.config.from_object("conf.default")
settings = conf.default

if "WOOJUU_MODE" in os.environ:
    if os.environ["WOOJUU_MODE"].lower() == "production":
        app.logger.info("Loading production settings...")
        settings = conf.prod
        app.config.from_object("conf.prod")
