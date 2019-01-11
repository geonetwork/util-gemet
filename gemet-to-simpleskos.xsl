<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs='http://www.w3.org/2000/01/rdf-schema#'
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:foaf="http://xmlns.com/foaf/0.1/"
                xmlns:gemet="http://www.eionet.europa.eu/gemet/2004/06/gemet-schema.rdf#"
                version="2.0">
  <!--
  Convert GEMET Skos files into a simple skos structure
  managed by GeoNetwork opensource.
  -->

  <xsl:output method="xml" indent="yes"/>

  <xsl:variable name="debug" select="false()"/>
  <xsl:variable name="maxStringLength" select="254"/>
  <xsl:variable select="document('locales.xml')" name="locales"/>
  <xsl:variable select="document('gemet-skoscore.rdf')" name="skoscore"/>
  <xsl:variable name="root" select="/"/>


  <!-- Disabled by default as the thesaurus would be too big-->
  <xsl:variable name="withGroup" select="false()"/>

  <xsl:variable name="withThemes" select="true()"/>

  <!-- Concept, group and supergroup descriptions -->
  <xsl:variable name="lang">
    <lang>
      <xsl:for-each select="$locales//locale">
        <xsl:copy-of
          select="document(concat('gemet-definitions-', ., '.rdf'))"/>
        <xsl:copy-of select="document(concat('gemet-groups-', ., '.rdf'))"/>
      </xsl:for-each>
    </lang>
  </xsl:variable>


  <xsl:template name="header">
    <!-- Scheme -->
    <skos:ConceptScheme rdf:about="http://geonetwork-opensource.org/gemet">
      <dc:title>GEMET</dc:title>
      <dc:description>GEMET version 4.1.2 thesaurus for GeoNetwork opensource.</dc:description>
      <dc:creator>
        <foaf:Organization>
          <foaf:name>EEA</foaf:name>
        </foaf:Organization>
      </dc:creator>
      <dc:uri>https://www.eionet.europa.eu/gemet/about?langcode=en</dc:uri>
      <dc:rights>https://www.eionet.europa.eu/gemet/about?langcode=en</dc:rights>
      <dcterms:issued>2018-08-16</dcterms:issued>
      <dcterms:modified>2018-08-16</dcterms:modified>

      <xsl:comment>Generated <xsl:value-of select="current-dateTime()"/>.
      </xsl:comment>
      <xsl:text>
      </xsl:text>

      <xsl:choose>
        <xsl:when test="$withGroup">
          <skos:hasTopConcept
            rdf:resource="http://www.eionet.europa.eu/gemet/supergroups"/>

          <xsl:for-each-group
            select="//rdf:Description[matches(@rdf:about, 'supergroup/[0-9]+$')]"
            group-by="@rdf:about">
            <xsl:sort select="@rdf:about"/>
            <skos:hasTopConcept
              rdf:resource="http://www.eionet.europa.eu/gemet/{@rdf:about}"/>
          </xsl:for-each-group>

        </xsl:when>
        <xsl:when test="$withThemes">
          <skos:hasTopConcept
            rdf:resource="http://www.eionet.europa.eu/gemet/themes"/>

          <xsl:for-each-group
            select="//rdf:Description[matches(@rdf:about, 'theme/[0-9]+$')]"
            group-by="@rdf:about">
            <xsl:sort select="@rdf:about"/>
            <skos:hasTopConcept
              rdf:resource="http://www.eionet.europa.eu/gemet/{@rdf:about}"/>
          </xsl:for-each-group>
        </xsl:when>
        <xsl:otherwise>
          <!-- All concept with no broader term -->
          <xsl:for-each
            select="$skoscore//skos:Concept[matches(@rdf:about, 'concept/[0-9]+$') and not(skos:broader)]">
            <xsl:sort select="@rdf:about"/>
            <skos:hasTopConcept
              rdf:resource="http://www.eionet.europa.eu/gemet/{@rdf:about}"/>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>

    </skos:ConceptScheme>
  </xsl:template>


  <!-- Based on gemet-backbone.rdf -->
  <xsl:template match="/">
    <rdf:RDF>
      <xsl:call-template name="header"/>

      <xsl:if test="$withGroup">
        <xsl:comment>GEMET supergroups</xsl:comment>
        <xsl:text>
        </xsl:text>

        <skos:Concept rdf:about="http://www.eionet.europa.eu/gemet/supergroups">
          <xsl:for-each select="$locales//locale">
            <skos:prefLabel xml:lang="{{.}}">GEMET super groups</skos:prefLabel>
          </xsl:for-each>
        </skos:Concept>


        <xsl:for-each
          select="//rdf:Description[matches(@rdf:about, 'supergroup/[0-9]+$')]">
          <xsl:sort select="@rdf:about"/>
          <xsl:variable name="id" select="@rdf:about"/>

          <skos:Concept rdf:about="http://www.eionet.europa.eu/gemet/{$id}">
            <xsl:for-each
              select="$lang//rdf:Description[@rdf:about = $id]">
              <xsl:variable name="l" select="../@xml:lang"/>

              <xsl:if
                test="normalize-space(rdfs:label) != ''">
                <xsl:element name="skos:prefLabel">
                  <xsl:attribute name="xml:lang">
                    <xsl:value-of select="$l"/>
                  </xsl:attribute>
                  <xsl:value-of select="rdfs:label"/>
                </xsl:element>
              </xsl:if>
            </xsl:for-each>

            <!-- Search groups -->
            <xsl:for-each
              select="//gemet:subGroupOf/rdf:Description[@rdf:about = $id]/skos:member/@rdf:resource">
              <skos:narrower
                rdf:resource="http://www.eionet.europa.eu/gemet/{.}"/>
            </xsl:for-each>

            <skos:broader rdf:resource="http://www.eionet.europa.eu/gemet/supergroups"/>
          </skos:Concept>
        </xsl:for-each>

        <xsl:comment>GEMET groups</xsl:comment>
        <xsl:text>
        </xsl:text>
        <xsl:for-each-group
          select="//rdf:Description[matches(@rdf:about, 'group/[0-9]+$')]"
          group-by="@rdf:about">
          <xsl:sort select="@rdf:about"/>
          <xsl:variable name="id" select="@rdf:about"/>

          <skos:Concept rdf:about="http://www.eionet.europa.eu/gemet/{$id}">
            <xsl:for-each
              select="$lang//rdf:Description[@rdf:about = $id]">
              <xsl:variable name="l" select="../@xml:lang"/>

              <xsl:if
                test="normalize-space(rdfs:label) != ''">
                <xsl:element name="skos:prefLabel">
                  <xsl:attribute name="xml:lang">
                    <xsl:value-of select="$l"/>
                  </xsl:attribute>
                  <xsl:value-of select="rdfs:label"/>
                </xsl:element>
              </xsl:if>
            </xsl:for-each>

            <!-- Search groups -->
            <xsl:for-each
              select="//rdf:Description[@rdf:about = $id]/gemet:subGroupOf/rdf:Description/@rdf:about">
              <skos:broader
                rdf:resource="http://www.eionet.europa.eu/gemet/{.}"/>
            </xsl:for-each>
            <!-- Search term -->
            <xsl:for-each
              select="//gemet:group/rdf:Description[@rdf:about = $id]/skos:member/@rdf:resource[starts-with(., 'concept')]">
              <skos:narrower
                rdf:resource="http://www.eionet.europa.eu/gemet/{.}"/>
            </xsl:for-each>
          </skos:Concept>
        </xsl:for-each-group>
      </xsl:if>

      <xsl:if test="$withThemes">
        <xsl:comment>GEMET themes</xsl:comment>

        <skos:Concept rdf:about="http://www.eionet.europa.eu/gemet/themes">
          <xsl:for-each select="$locales//locale">
            <skos:prefLabel xml:lang="{.}">GEMET themes</skos:prefLabel>
          </xsl:for-each>
        </skos:Concept>

        <xsl:for-each-group
          select="//rdf:Description[matches(@rdf:about, 'theme/[0-9]+$')]"
          group-by="@rdf:about">
          <xsl:sort select="@rdf:about"/>
          <xsl:variable name="id" select="@rdf:about"/>

          <skos:Concept rdf:about="http://www.eionet.europa.eu/gemet/{$id}">
            <xsl:for-each
                    select="$lang//rdf:Description[@rdf:about = $id]">
              <xsl:variable name="l" select="../@xml:lang"/>

              <xsl:if
                      test="normalize-space(rdfs:label) != ''">
                <xsl:element name="skos:prefLabel">
                  <xsl:attribute name="xml:lang">
                    <xsl:value-of select="$l"/>
                  </xsl:attribute>
                  <xsl:value-of select="rdfs:label"/>
                </xsl:element>
              </xsl:if>
            </xsl:for-each>

            <xsl:if test="$withGroup">
              <xsl:for-each select="//gemet:subGroupOf/rdf:Description/@rdf:about">
                <skos:broader rdf:resource="http://www.eionet.europa.eu/gemet/{.}"/>
              </xsl:for-each>
            </xsl:if>

            <skos:broader rdf:resource="http://www.eionet.europa.eu/gemet/themes"/>

            <!-- Search term -->
            <xsl:for-each
              select="$root//rdf:Description[gemet:theme/rdf:Description/@rdf:about = $id][starts-with(@rdf:about, 'concept')]">
              <skos:narrower
                rdf:resource="http://www.eionet.europa.eu/gemet/{@rdf:about}"/>
            </xsl:for-each>
          </skos:Concept>
        </xsl:for-each-group>
      </xsl:if>

      <xsl:comment>GEMET concepts</xsl:comment>
      <xsl:text>
      </xsl:text>

      <xsl:for-each
        select="//rdf:Description[matches(@rdf:about, 'concept/[0-9]+$')]">
        <xsl:sort select="@rdf:about"/>
        <xsl:variable name="id" select="@rdf:about"/>

        <skos:Concept rdf:about="http://www.eionet.europa.eu/gemet/{$id}">
          <xsl:for-each
            select="$lang//rdf:Description[@rdf:about = $id]">
            <xsl:variable name="l" select="../@xml:lang"/>

            <xsl:if
              test="normalize-space(skos:prefLabel) != ''">
              <xsl:element name="skos:prefLabel">
                <xsl:attribute name="xml:lang">
                  <xsl:value-of select="$l"/>
                </xsl:attribute>
                <xsl:value-of select="skos:prefLabel"/>
              </xsl:element>
            </xsl:if>
            <xsl:if test="normalize-space(skos:definition) != '' or
                          normalize-space(skos:scopeNote) != ''">
              <xsl:element name="skos:scopeNote">
                <xsl:attribute name="xml:lang">
                  <xsl:value-of select="$l"/>
                </xsl:attribute>
                <xsl:value-of select="skos:definition|skos:scopeNote"/>
              </xsl:element>
            </xsl:if>
          </xsl:for-each>


          <xsl:if test="$withGroup">
            <xsl:for-each select="gemet:group/rdf:Description/@rdf:about">
              <skos:broader
                rdf:resource="http://www.eionet.europa.eu/gemet/{.}"/>
            </xsl:for-each>
          </xsl:if>

          <xsl:if test="$withThemes">
            <xsl:for-each select="gemet:theme/rdf:Description/@rdf:about">
              <skos:broader
                rdf:resource="http://www.eionet.europa.eu/gemet/{.}"/>
            </xsl:for-each>
          </xsl:if>
          <xsl:for-each select="$skoscore//skos:Concept[@rdf:about = $id]/
                                  *[local-name() = 'narrower' or
                                    local-name() = 'broader' or
                                    local-name() = 'related']">
            <xsl:copy>
              <xsl:attribute name="rdf:resource"
                             select="concat('http://www.eionet.europa.eu/gemet/', @rdf:resource)"/>
            </xsl:copy>
          </xsl:for-each>
        </skos:Concept>
      </xsl:for-each>
    </rdf:RDF>
  </xsl:template>
</xsl:stylesheet>
