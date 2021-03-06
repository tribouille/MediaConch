<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mc="https://mediaarea.net/mediatrace" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" extension-element-prefixes="xsi">
    <xsl:output encoding="UTF-8" method="xml" version="1.0" indent="yes"/>

    <xsl:template match="mc:MediaTrace">
        <MediaConch>

            <!-- start ebml variables -->
            <xsl:variable name="DocTypeVersion">
                <xsl:choose>
                    <xsl:when test="mc:block[@name='Ebml']/mc:block[@name='DocTypeVersion']/mc:data[@name='Data']">
                        <xsl:value-of select="mc:block[@name='Ebml']/mc:block[@name='DocTypeVersion']/mc:data[@name='Data']"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- default value if there is no element -->
                        <xsl:text>1</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="DocTypeReadVersion">
                <xsl:choose>
                    <xsl:when test="mc:block[@name='Ebml']/mc:block[@name='DocTypeReadVersion']/mc:data[@name='Data']">
                        <xsl:value-of select="mc:block[@name='Ebml']/mc:block[@name='DocTypeReadVersion']/mc:data[@name='Data']"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- default value if there is no element -->
                        <xsl:text>1</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <!-- end ebml variables -->

            <conformanceChecks>
                <xsl:attribute name="version">
                    <xsl:text>0.1a1</xsl:text>
                </xsl:attribute>
                    <check>
                        <xsl:attribute name="id">EBML-ELEM-START</xsl:attribute>
                        <xsl:attribute name="version">0</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="//mc:data[1] = '172351395'">
                                <outcome>
                                    <xsl:attribute name="outcome">pass</xsl:attribute>
                                </outcome>
                            </xsl:when>
                            <xsl:otherwise>
                                <outcome>
                                    <xsl:attribute name="outcome">fail</xsl:attribute>
                                    <xsl:attribute name="reason">unexpected value</xsl:attribute>
                                    <value>
                                        <xsl:attribute name="offset">
                                            <xsl:value-of select="//mc:data[1]/@offset"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="expected">172351395</xsl:attribute>
                                        <xsl:attribute name="name">FirstBlock</xsl:attribute>
                                        <xsl:value-of select="//mc:data[1]"/>
                                    </value>
                                </outcome>
                            </xsl:otherwise>
                        </xsl:choose>
                    </check>
                    <check>
                        <xsl:attribute name="id">EBML-VER-COH</xsl:attribute>
                        <xsl:attribute name="version">0</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$DocTypeVersion >= $DocTypeReadVersion">
                                <outcome>
                                    <xsl:attribute name="outcome">pass</xsl:attribute>
                                </outcome>
                            </xsl:when>
                            <xsl:otherwise>
                                <outcome>
                                    <xsl:attribute name="outcome">fail</xsl:attribute>
                                    <xsl:attribute name="reason">illogical mismatch</xsl:attribute>
                                    <value>
                                        <xsl:attribute name="offset">
                                            <xsl:value-of select="mc:block[@name='Ebml']/mc:block[@name='DocTypeVersion']/@offset"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="name">DocTypeVersion</xsl:attribute>
                                        <xsl:value-of select="$DocTypeVersion"/>
                                    </value>
                                    <value>
                                        <xsl:attribute name="offset">
                                            <xsl:value-of select="mc:block[@name='Ebml']/mc:block[@name='DocTypeReadVersion']/@offset"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="name">DocTypeReadVersion</xsl:attribute>
                                        <xsl:value-of select="$DocTypeReadVersion"/>
                                    </value>
                                </outcome>
                            </xsl:otherwise>
                        </xsl:choose>
                    </check>
            </conformanceChecks>
        </MediaConch>
    </xsl:template>
</xsl:stylesheet>
