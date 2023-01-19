package com.sailpoint.pse.iiqdoc;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Properties;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

public class LocalizationConverter {

	String inFileName = null;
	String outFileName = null;

	public LocalizationConverter(String inFileName, String outFileName) {
		this.inFileName = inFileName;
		this.outFileName = outFileName;
	}

	private String otos(Object o) {
		if (o == null)
			return null;
		if (o instanceof String)
			return (String) o;
		return o.toString();
	}

	private String stripHtml(String in) {
		if (in != null)  {
			return in.replaceAll("\\<[^>]*>","");
		}
		return null;
	}
	
	public void execute() throws IOException, ParserConfigurationException, TransformerFactoryConfigurationError, TransformerException {
		Properties properties = new Properties();
		InputStream is = null;
		OutputStream os = null;
		if (inFileName != null) {
			File inFile = new File(inFileName);
			if (inFile.exists() && inFile.isFile() && inFile.canRead()) {
				is = new FileInputStream(inFile);
			} else {
				throw new IOException(String.format("Cannot read file '%s'", inFileName));
			}
		} else {
			is = System.in;
		}
		if (outFileName != null) {
			File outFile = new File(outFileName);
			if (outFile.canWrite()) {
				os = new FileOutputStream(outFile);
			} else {
				throw new IOException(String.format("Cannot write file '%s'", outFileName));
			}
		} else {
			os = System.out;
		}

		try {
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			factory.setNamespaceAware(true);
			factory.setValidating(false);
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document document = builder.newDocument();
			Element rootElement = document.createElement("xsl:stylesheet");
			rootElement.setAttribute("version", "1.0");
			rootElement.setAttribute("xmlns:xsl", "http://www.w3.org/1999/XSL/Transform");
			rootElement.setAttribute("xmlns:iiqdoc", "http://iiqdoc.config.data");
			document.appendChild(rootElement);
			
			Element localizations = document.createElement("iiqdoc:localizations");
			rootElement.appendChild(localizations);

			properties.load(is);
			for (Object key : properties.keySet()) {
				String value = otos(properties.get(key));
				Element localization = document.createElement("iiqdoc:localization");
				localization.setAttribute("key", otos(key));
				localization.setAttribute("value", stripHtml(value));
				localizations.appendChild(localization);
			}

			Transformer transformer = TransformerFactory.newInstance().newTransformer();
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			transformer.setOutputProperty(OutputKeys.METHOD, "xml");
			transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
            transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
            transformer.transform(new DOMSource(document), new StreamResult(os));
		} finally {
			if (is != null && inFileName != null) {
				is.close();
			}
			if (os != null && outFileName != null) {
				os.close();
			}
		}
	}

	public static void main(String[] args) throws IOException, ParserConfigurationException, TransformerFactoryConfigurationError, TransformerException {
		String inFileName = null;
		String outFileName = null;
		if (args != null && args.length > 0) {
			inFileName = args[0];
			if (args.length > 1) {
				outFileName = args[1];
			}
		}
		LocalizationConverter converter = new LocalizationConverter(inFileName, outFileName);
		converter.execute();
	}

}
