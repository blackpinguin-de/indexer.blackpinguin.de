# English

In the winter semester 2013/14 Prof. Dr. [Edmund Weitz](http://weitz.de/)[1] started to record all of his lectures and distributed them online.

Because I find the ViMP [media center](http://mediathek.mt.haw-hamburg.de/) too unintuitive and unclear, it didn't offer download links at that time, and it doesn't have the features I need, I developed a simple web crawler in one weekend. It automatically searches for new videos, caches them in a local database and generates a clear and simple index for the media center as an static HTML file. Videos get structurally grouped by course and by lecture date and can be marked by the website user via checkboxes [2].

The Media Indexer was extended between the winter semester 2013/14 and the summer semester 2014 by the following features for a minor honorarium:

- Additional structure group: semesters.
- Summation of video duration and number of videos.
- Configuration file, to set the media center URL, where the data inside the HTML-DOM resides and how it is parsed.
- Configuration file, to arbitrarily change the structure of the index, as well as changing the regular expressions to determine structure membership.
- Macros for the configuration files, to determine the date and semester by the program, to use them as structuring elements.
- More command line parameters[3].
- The internal database have changed from CSV to XML.
- The HTML generation isn't programmed into the binary executable anymore, but is outsourced to a XSLT file.
- Additional output: RSS-Feeds (likewise via XSLT)
- Generating subpages for semesters and couses, to not always have to load the huge front page.
- Multithreading: asynchronous HTTP requests, analysis and output generation are all parallelized[4]
- Improved exception handling, logging and reporting.

Between the summer semester 2014 and the winter semester 2014/15 it was again slightly extended:

- Bugfix: operating system dependent problems with umlauts in course names[5].
- Manually implemented and optimized insertion sort algorithm, which is, contrary to the quicksort algorithm of Arrays.sort, better fitted for this application [6].
- Additional outputs: XML[7] and JSON (both via XSLT).

In the winter semester 2014/15 the Media Indexer was extended with a comment counter, to highlight potentially important remarks and corrections.

The Media Indexer is used by Prof. Dr. Weitz, in a [private area](http://weitz.de/haw-videos/) of his website, that only students with the correct password can access, and by me on [my website](https://indexer.blackpinguin.de/). Both instances use the same software, but differ in the configuration files[8].

|                  |                                                                                                                                                                  |
| ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| __Languages__    | Scala, XML, XSLT, HTML, CSS, JavaScript, JSON                                                                                                                    |
| __Technologies__ | Async Http Client, HtmlCleaner, Xerces, Xalan, EXSLT, Futures, Scala Regex, StringEscapeUtils, ThreadLocal, Java Properties, XPath, XSD, DTD, HTML5, jQuery, RSS |
| __IDE__          | Eclipse with Scala IDE                                                                                                                                           |
| __Participants__ | 1                                                                                                                                                                |

### Footnotes

- [1]	My lecturer in: [Mathematics 1](https://rcl.blackpinguin.de/haw/bms/13ss/M1/), [Mathematics 2](https://rcl.blackpinguin.de/haw/bms/13ws/M2/), [Selected Topics of Media Computer Science](https://rcl.blackpinguin.de/haw/bms/14ss/MINF/) and [Theoretical Computer Science](https://rcl.blackpinguin.de/haw/bms/14ws/TI/).
- [2]	The state of the checkboxes, and which structure element is open or closed, are of course locally saved in the browser, and not transmitted over cookies or similiar, remaining unknown to the web server.
- [3]	Manually delete or update single videos, generating the index without a search (e.g. when the config files have changes), reset the local database and start from scratch, etc.
- [4]	The numbers aren't comparable, because of all the new features, but the running time for a complete run improved from 6.3 minutes with 461 videos to 3.3 minutes with 518 videos. Usually there isn't a complete run over all pages and all videos, but a small run over only the first few pages and videos that were added since the last run.
- [5]	The course names are used as directory names, forming the URLs of the subpages. The program is configured to use UTF-8 whenever possible, but nonetheless on one of three systems the file system prevented subpages with umlauts to update.
- [6]	The old elements are already sorted and new elements will usually be added to the end and rearranged only with other new elements.
- [7]	Based on the XML format, a fellow student made a [Python script](https://github.com/jmnx/AL-ViDo/), that automatically downloads all video files of one course.
- [8]	In contrary, my configuration accepts video files that other lecturers might have added to the media center, and lists videos for that no rule has matched as 'Unsortiert' (engl.: unsorted).

# Deutsch

Prof. Dr. [Edmund Weitz](http://weitz.de/)[1] begann im Wintersemester 2013/14 damit, alle seine Vorlesungen aufzuzeichnen und online zur Verfügung zu stellen.

Weil mir die [ViMP-Mediathek](http://mediathek.mt.haw-hamburg.de/) zu unübersichtlich ist, sie damals keine Downloadmöglichkeit enthielt und nicht die Features bietet die ich gerne hätte, entwickelte ich an einem Wochenende einen simplen Webcrawler, der automatisiert nach neuen Videos sucht, eine lokale Datenbank pflegt und einen übersichtlichen HTML-Index erstellt. Videos werden nach Vorlesung und Datum gruppiert, und sie können manuell mit einer Checkbox vom Webseitenbesucher markiert werden[2].

Der Media Indexer wurde zwischen dem Wintersemester 2013/14 und dem Sommersemester 2014 gegen ein kleines Honorar um folgende Features erweitert:

- Zusätzlicher Gliederungspunkt: Semester.
- Videodauer und Anzahl der Videos aufsummieren.
- Konfigurationsdatei, um einstellen zu können welche URL die Mediathek hat, wo im HTML-DOM die Informationen liegen und wie sie zu parsen sind.
- Konfigurationsdatei, um die Gliederung beliebig zu ändern, sowie mittels regulärer Ausdrücke die Zugehörigkeit zu den Gliederungspunkten einzustellen.
- Makros für die Konfigurationsdatei, um das Datum und das Semester vom Indexer erkennen zu lassen und in der Gliederung, beliebig verwenden zu können.
- Mehr Kommandozeilenparameter[3].
- Die interne Datenbank geändert von CSV zu XML.
- Ausgabe-HTML nicht mehr fest einprogrammiert, sondern über XSLT erzeugen.
- Zusätzliche Ausgabe: RSS-Feeds (ebenfalls über XSLT).
- Unterseiten, für Semester und Vorlesungen, generieren, um nicht immer die riesige Startseite laden zu müssen.
- Multithreading: asynchrone HTTP-Anfragen, Auswertung und Outputgenerierung alles parallelisiert[4].
- Verbesserter Umgang mit, sowie Protokollierung und Benachrichtigung bei, Exceptions

Zwischen dem Sommersemester 2014 und dem Wintersemester 2014/15 wurde der Indexer erneut leicht überarbeitet:

- Bugfix: Betriebssystemabhängige Probleme mit Umlauten in Veranstaltungsnamen[5].
- Manuell implementierter und optimierter Insertionsort-Sortieralgorithmus, welcher entgegen dem Quicksort von Arrays.sort besser für diese Anwendung geeignet ist [6].
- weitere Ausgabeformate: XML[7] und JSON (beides über XSLT).

Im Wintersemester 2014/15 wurde der Indexer um einen Kommentarzähler ergänzt, um evtl. wichtige Anmerkungen und Korrekturen hervorzuheben.

Angewendet wird der Media Indexer, einerseits von Prof. Dr. Weitz auf einem [geschützten Bereich](http://weitz.de/haw-videos/) seiner Webseite, auf den nur Studierende mit Passwort Zugriff haben, und anderseits von mir auf [meiner Webseite](https://indexer.blackpinguin.de/). Beide Instanzen verwenden dieselbe Software, unterscheiden sich aber etwas in den Konfigurationsdateien[8].

|                  |                                                                                                                                                                  |
| ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| __Sprachen__     | Scala, XML, XSLT, HTML, CSS, JavaScript, JSON                                                                                                                    |
| __Technologien__ | Async Http Client, HtmlCleaner, Xerces, Xalan, EXSLT, Futures, Scala Regex, StringEscapeUtils, ThreadLocal, Java Properties, XPath, XSD, DTD, HTML5, jQuery, RSS |
| __IDE__          | Eclipse mit Scala IDE                                                                                                                                            |
| __Beteiligte__   | 1                                                                                                                                                                |

### Fußnoten

- [1]	Mein Dozent in: [Mathematik 1](https://rcl.blackpinguin.de/haw/bms/13ss/M1/?lang=de), [Mathematik 2](https://rcl.blackpinguin.de/haw/bms/13ws/M2/?lang=de), [Ausgewählte Themen der Medieninformatik](https://rcl.blackpinguin.de/haw/bms/14ss/MINF/?lang=de) und [Theoretische Informatik](https://rcl.blackpinguin.de/haw/bms/14ws/TI/?lang=de).
- [2]	Die Zustände der Checkboxen, und welche Gliederungspunkte auf oder zugeklappt sind, werden selbstverständlich lokal im Browser gespeichert, nicht über Cookies oder ähnliches übertragen und sind dem Webserver deshalb unbekannt.
- [3]	Manuell einzelne Videos löschen/aktualisieren, den Index neu generieren ohne Suche (z.B. bei geänderter Konfigurationsdatei), die Datenbank zurücksetzen und alles erneut erzeugen, usw.
- [4]	Die Zahlen sind durch die vielen neuen Funktionen nicht direkt vergleichbar, aber die Laufzeit für einen vollständigen Lauf hat sich von 6.3 Minuten bei 461 Videos auf 3.3 Minuten bei 518 Videos verbessert. In der Regel wird kein vollständiger Lauf über alle Seiten und Videos durchgeführt, sondern es werden nur die ersten etwa 1-2 Seiten und neu hinzugekommene Videos aufgerufen.
- [5]	Die Namen der Lehrveranstaltungen werden als Ordnernamen verwendet und bilden dadurch die URLs für die Unterseiten. Das Programm ist in jeder Hinsicht explizit auf UTF-8 konfiguriert, aber trotzdem sorgte auf einem von drei Computern das Dateisystem dafür, dass Unterseiten mit Umlauten nicht mehr aktualisiert wurden.
- [6]	Die alten Daten sind bereits sortiert und neu hinzukommende Einträge werden meist nur hinten angehängt und untereinander sortiert.
- [7]	Basierend auf dem XML-Format hat ein Kommilitone ein [Python-Skript](https://github.com/jmnx/AL-ViDo/) erstellt, womit automatisch alle Videos einer Lehrveranstaltung heruntergeladen werden können.
- [8]	Meine Konfiguration akzeptiert prinzipiell auch Videos, die von anderen Dozenten in die Mediathek eingestellt werden, und listet Videos für die keine Regel angelegt wurde als unsortiert.
