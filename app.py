from flask import Flask, request, render_template
from os import system, path
import subprocess

app = Flask(__name__)
app.debug = True

@app.after_request
def add_header(response):
    response.headers['Cache-Control'] = 'no-cache, no-store'
    return response

@app.route('/static/<path:path>')
def static_file(path):
    return app.send_static_file(os.path.join(path))

@app.route('/viz', methods=['GET'])
def viz():
    video = request.args.get('video')
    if not video:
        print "No Video Specified"
        video = "http://www.youtube.com/watch?v=moSFlvxnbgk"
    print "Video: %s" % video
    cmd = ["./video2images.sh",video]
    system(' '.join(cmd))
    return render_template('viz.html', video=video.replace('watch?v=','embed/',1)+"?showinfo=0")

@app.route('/', methods=['GET'])
def form():
    return render_template('form.html')

if __name__ == '__main__':
    app.run()
