from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return '''
    <html>
      <head><title>GCP Load Balancer Demo</title></head>
      <body style="text-align:center;">
        <h1>✅ App is Live Behind GCP Load Balancer!</h1>
        <p>Served from VM via HTTP</p>
      </body>
    </html>
    '''

@app.route('/api')
def api():
    return {"message": "API is reachable", "status": "OK"}

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)

