FROM python:3

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update && apt-get install -y nodejs npm vim git

RUN useradd -ms /bin/bash guso
ENV PATH="/home/guso/.local/bin:${PATH}"
USER guso
WORKDIR /home/guso


COPY requiriments.txt .
RUN pip install --user -r requiriments.txt
RUN rm requiriments.txt

RUN jupyter-lab --generate-config
RUN ipython profile create

COPY ipython_config.py /home/guso/.ipython/profile_default/ipython_config.py
COPY jupyter_notebook_config.py /home/guso/.jupyter/jupyter_notebook_config.py

RUN jupyter labextension install jupyter-matplotlib
RUN jupyter labextension install @jupyterlab/toc

RUN mkdir code
ENV PYTHONPATH="/home/guso/code:${PYTHONPATH}"
RUN touch code/__init__.py
CMD ["/home/guso/.local/bin/jupyter-lab", "--NotebookApp.token='abcd1234'"]
