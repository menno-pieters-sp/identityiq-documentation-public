package com.sailpoint.pse.util;

import java.text.SimpleDateFormat;
import java.util.SimpleTimeZone;

public class TimeTool {

	public TimeTool() {
		// TODO Auto-generated constructor stub
	}
	
	public static String formatDurationSeconds(int s) {
		String formatStr = "HH:mm:ss";
		if (s >= 24*60*60) {
			formatStr = "D HH:mm:ss";
		}
		SimpleDateFormat sdf = new SimpleDateFormat(formatStr);
		sdf.setTimeZone(new SimpleTimeZone(0, "UTC"));
		return sdf.format(s * 1000);
	}

	public static String formatDurationSeconds(Object so) {
		if (so != null) {
			int s = 0;
			if (so instanceof Number) {
				s = (int) so;
			} else if (so instanceof String) {
				try {
					s = Integer.parseInt((String) so);
				} catch (NumberFormatException e) {
					// Silently ignore.
					return null;
				}
			}
			return formatDurationSeconds(s);
		}
		return null;
	}

}
