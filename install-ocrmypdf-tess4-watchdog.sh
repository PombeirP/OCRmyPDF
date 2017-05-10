#!/bin/sh

apt-get update && apt-get install -y --no-install-recommends \
  software-properties-common python-software-properties \
  python3-wheel \
  python3-reportlab \
  python3-venv \
  ghostscript \
  qpdf \
  poppler-utils \
  unpaper \
  libffi-dev

add-apt-repository ppa:alex-p/tesseract-ocr

apt-get update \
	&& apt-get autoremove -y \
	&& apt-get install -y --no-install-recommends \
         tesseract-ocr \
         tesseract-ocr-eng \
         tesseract-ocr-fra \
         tesseract-ocr-deu \
         tesseract-ocr-por \
         tesseract-ocr-ita

python3 -m venv --system-site-packages /appenv

# This installs the latest binary wheel instead of the code in the current
# folder. Installing from source will fail, apparently because cffi needs
# build-essentials (gcc) to do a source installation 
# (i.e. "pip install ."). It's unclear to me why this is the case.
. /appenv/bin/activate; \
  pip install --upgrade pip \
  && pip install --no-cache-dir ocrmypdf

apt-get update \
  && apt-get install -y --no-install-recommends \
	           build-essential \
	           libyaml-dev \
	           python3-dev \
	           python3-pip

. /appenv/bin/activate; \
pip install --upgrade pip \
  && easy_install watchdog

apt-get remove -y \
  build-essential \
  libyaml-dev \
  python3-dev \
  python3-pip

# Remove the junk
rm -rf /tmp/* /var/tmp/* /root/* \
  && apt-get autoremove -y \
  && apt-get autoclean -y
