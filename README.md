# IdentityIQ Documentation Tool

This tool allows customers and implementers to automatically create documentation for their IdentityIQ configuration, based on XML configuration files. These files should be merged into a single XML document.

## File Collection

There are two common ways to get the configuration files for documentation:
1. Console export
1. Collect files from SSB/SSD build

### Console Export
Files can be exported from the IdentityIQ console by listing the object types to be exported, for example:
```
> export -clean /home/jdoe/export.xml Application Rule Bundle ObjectConfig
```

This will produce a single file with all objects of the specified object classes. It will also include any out-of-the-box objects.

### Collect File from SSB/SSG build

In this scenario, only customized/updated files would be included. First of all, the SSB/SSD command to build the configuration and sources would have to be issued to generate all the configuration files with all parameterized settings filles in. For example:

```
./build.sh -Dtarget=production clean war
```

After that command completes successfully, the configuration files will be located under `build/extract/WEB-INF/config/custom`. These files can be combined into a single file using the [SailPointXMLMerger][https://github.com/menno-pieters-sp/sailpoint-xml-merger] tool.

Assuming that this tool is located under `/home/jdoe/lib` as `SailPointXMLMerger.jar` and output should be filed under `/home/jdoe/Documents`, the command could look like this:

```
java -jar /home/jdoe/lib/SailPointXMLMerger.jar build/extract/WEB-INF/config/custom > /home/jdoe/Documents/identityiq-production.xml
```

## Usage

Assuming you have a file `/home/jdoe/Documents/identityiq-production.xml`, you must also place the DTD file for the IdentityIQ version in the same folder with the name `sailpoint.dtd`. Also assuming the documentation tool is installed under `/home/jdoe/lib` as `IdentityIQDocumentationGenerator.jar` and the XSLT files under `/home/jdoe/xslt` Then, you can call the documentation tool as:

```
java -jar /home/jdoe/lib/IdentityIQDocumentationGenerator.jar -IN /home/jdoe/Documents/identityiq-production.xml -XSL /home/jdoe/xslt/IdentityIQ-Documenter.xsl -HTML > /home/jdoe/Documents/identityiq-production.html
```

The file `/home/jdoe/Documents//home/jdoe/Documents/identityiq-production.html` can then be viewed in a web browser.
