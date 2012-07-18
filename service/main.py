from common import app
import api

app.register_blueprint(api.api)
if __name__ == "__main__":
    api.setup()
    app.run()
