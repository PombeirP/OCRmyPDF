OCRmyPDF
========

`OCRmyPDF-watchdog` monitors a folder and adds an OCR text layer to added scanned PDF files, then moves them to an archive folder, allowing them to be searched or copy-pasted. It is derived from the awesome [OCRmyPDF project](https://github.com/jbarlow83/OCRmyPDF).

To use it in a docker-compose file:
```
  OCRmyPDF:
    image: pombeirp/ocr2pdf-watchdog
    container_name: OCRmyPDF
    network_mode: none
    volumes:
        - <path/to/archive/folder/on/host>:/archive
        - <path/to/watch/folder/on/host>:/hot-folder
        - /etc/localtime:/etc/localtime:ro
    environment:
      - PUID=<UID>
      - PGID=<GID>
      - "OCRMYPDF_OPTIONS=--pdf-renderer tess4 --tesseract-timeout 600 --author \"Your name\" --rotate-pages -l eng+fra+por+deu --deskew --clean --skip-text"
    restart: always
```

Main features
-------------

-  Generates a searchable [PDF/A](https://en.wikipedia.org/?title=PDF/A) file from a regular PDF
-  Places OCR text accurately below the image to ease copy / paste
-  Keeps the exact resolution of the original embedded images
-  When possible, inserts OCR information as a "lossless" operation without rendering vector information
-  Keeps file size about the same
-  If requested deskews and/or cleans the image before performing OCR
-  Validates input and output files
-  Provides debug mode to enable easy verification of the OCR results
-  Processes pages in parallel when more than one CPU core is
   available
-  Uses [Tesseract OCR](https://github.com/tesseract-ocr/tesseract) engine
-  Supports more than [100 languages](https://github.com/tesseract-ocr/tessdata) recognized by Tesseract
-  Battle-tested on thousands of PDFs, a test suite and continuous integration

For details: please consult the [documentation](https://ocrmypdf.readthedocs.io/en/latest/https://ocrmypdf.readthedocs.io/en/latest/).

Languages
---------

OCRmyPDF uses Tesseract for OCR, and relies on its language packs. For Linux users,
you can often find packages that provide language packs:

```bash
# Display a list of all Tesseract language packs
apt-cache search tesseract-ocr

# Debian/Ubuntu users
apt-get install tesseract-ocr-chi-sim  # Example: Install Chinese Simplified language back
```

You can then pass the `-l LANG` argument to OCRmyPDF to give a hint as to what languages it should search for. Multiple languages can be requested.

Disclaimer
----------

The software is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied.
