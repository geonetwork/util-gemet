#!/bin/sh
export GEONETWORK_HOME=../4/web/target/geonetwork
export CLASSPATH=.:$GEONETWORK_HOME/WEB-INF/lib/saxon-9.1.0.8b-patch.jar
export GEMET_VERSION=4.2.1

if [ $1 ]
then
    echo "Downloading GEMET thesaurus:"
    echo "  * backbone ..."
    wget https://www.eionet.europa.eu/gemet/gemet-backbone.rdf
    echo "  * skoscore ..."
    wget https://www.eionet.europa.eu/gemet/gemet-skoscore.rdf
    echo "  * langague files:"
    for locale in $*; do
        echo "  * groups ..."
        wget --output-document=gemet-groups-$locale.rdf https://www.eionet.europa.eu/gemet/gemet-groups.rdf?langcode=$locale
        echo "    loading: $locale ..."
        wget --output-document=gemet-definitions-$locale.rdf  https://www.eionet.europa.eu/gemet/gemet-definitions.rdf?langcode=$locale
    done

    # Creating list of locales for XSL processing
    export LOCALES="<locales>"
    export LIST=""
    for locale in $*; do
        export LOCALES=$LOCALES"<locale>"$locale"</locale>"
        export LIST=$LIST"-"$locale
    done
    export LOCALES=$LOCALES"</locales>"
    echo $LOCALES > locales.xml

    echo "Creating thesaurus ..."
    java net.sf.saxon.Transform -s:gemet-backbone.rdf -xsl:gemet-to-simpleskos.xsl -o:gemet$LIST.rdf version=$GEMET_VERSION

    echo "Deploying to thesauri directory:"
    mv gemet$LIST.rdf thesauri/.
    rm locales.xml
    rm *.rdf
    echo "Done."
else
    echo "Usage: ./gemet-to-simpleskos.sh en fr de";
    echo "to create a GEMET thesaurus with english, french and deutsch languages."
fi
