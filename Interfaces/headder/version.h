/* version.h -- Contains version and vendor information */

	/* Version numbering:
	 * A decimal VERSION has two effective decimal places.
	 * An integer VERSION_I is 100 times the decimal version.
	 * For example, VERSION 5.08 corresponds to VERSION_I 508
	 * Further detail can be provided thus: VERSION 5.08.3
	 * but VERSION_I must always be 100 times exactly, so
	 * in this example:
	 *    VERSION    5.08.3         // for printing strings to user
	 *    VERSION_I  508            // template for matching component dependencies
	 */

#define VERSION          "5.1 Build 0823"		// detailed build information for about box
#define MAJORVERSION     "5.1"		// major version for processes, etc
#define VERSION_I         510		// integer version of Version

#define VERSION_S        VERSION
 
#define PRODUCT_NAME              "Cohesion Designer"
#define PRODUCT_NAME_PREFIX       "Cohesion"
#define OUR_NAME                  "Cohesion Systems, Inc"
#define VENDOR_NAME               OUR_NAME
#define VENDOR_URL                "http://www.CohesionSystems.com"
#define VENDOR_COPYRIGHT_YEARS    "1999 - 2001"


