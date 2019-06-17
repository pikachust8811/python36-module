FROM ubuntu:18.04

LABEL Maintainer="Lish Chen" Email="pikachust8811@gmail.com"

# update list
RUN apt-get update

# install libact Basic Dependencies Debian (>= 7) / Ubuntu (>= 14.04)
RUN apt-get install -y \
  build-essential \
  gfortran \
  libatlas-base-dev \
  liblapacke-dev

# insstall python 3.6 and pip
RUN apt-get install -y \
  curl \
  python3.6 \
  python3-dev && \
  curl -s -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
  python3.6 /tmp/get-pip.py

COPY requirements.txt /workspace/requirements.txt

WORKDIR /workspace

# install libact Python dependencies
RUN pip install -r requirements.txt

# install libact library
RUN pip install libact

RUN pip install jupyter

RUN jupyter notebook --generate-config && \
  echo "c.Application.log_level = 'DEBUG'" >> ~/.jupyter/jupyter_notebook_config.py && \
  echo "c.NotebookApp.ip = '0.0.0.0'" >> ~/.jupyter/jupyter_notebook_config.py && \
  echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py && \
  echo "c.NotebookApp.port = 8888" >> ~/.jupyter/jupyter_notebook_config.py && \
  echo "c.NotebookApp.token = u'JUPYTER_AUTH_TOKEN'" >> ~/.jupyter/jupyter_notebook_config.py && \
  echo "c.NotebookApp.notebook_dir = '/workspace/jupyter'" >> ~/.jupyter/jupyter_notebook_config.py && \
  echo "c.FileContentsManager.delete_to_trash = False" >> ~/.jupyter/jupyter_notebook_config.py && \
  mkdir /workspace/jupyter

COPY ./libact/examples/ /workspace/examples/

COPY bootstrap.sh /etc/bootstrap.sh
RUN chmod +x /etc/bootstrap.sh

CMD ["/etc/bootstrap.sh", "-bash"]