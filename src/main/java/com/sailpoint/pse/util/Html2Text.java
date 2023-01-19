/**
 * 
 */
package com.nnit.iamservices.novoaccess.applicationAgreement.util;

import java.io.IOException;
import java.io.Reader;
import java.io.StringReader;

import javax.swing.text.html.HTMLEditorKit.ParserCallback;
import javax.swing.text.html.parser.ParserDelegator;
/*
 * Workfile:     Html2Text.java
 * Purpose:      A class to strip HTML from a text.
 *
 * Created date: 2019.04.25
 * Created by:   MEOP
 *
 * Review date:  
 * Reviewed by:  
 *
 * Date       Author   ChangeTicket/Description
 * -----------------------------------------------------------------------------
 * 2019.04.25 MEOP     TMLS #467 Initial implementation

/**
 *         Inspiration from
 *         http://www.codecodex.com/wiki/Convert_HTML_to_plain_text
 * 
 */
public class Html2Text extends ParserCallback {

	private StringBuffer s;

	/**
	 * Default constructor
	 */
	public Html2Text() {
	}

	public String parse(String str) throws IOException {
		if (str != null) {
			StringReader stringReader = new StringReader(str);
			this.parse(stringReader);			
			return this.getText();
		}
		return null;
	}
	
	/**
	 * Read an input stream and feed it to the parser.
	 * 
	 * @param in
	 * @throws IOException
	 */
	public void parse(Reader in) throws IOException {
		s = new StringBuffer();
		ParserDelegator delegator = new ParserDelegator();
		// the third parameter is TRUE to ignore charset directive
		delegator.parse(in, this, Boolean.TRUE);
	}

	/**
	 * When text is received, append it to the internal StringBuffer.
	 * 
	 * @param text
	 * @param pos
	 */
	public void handleText(char[] text, int pos) {
		s.append(text);
	}

	/**
	 * Return the current contents of the StringBuffer.
	 * 
	 * @return
	 */
	public String getText() {
		return s.toString();
	}
}

