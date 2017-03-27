// dwgctrl.h - drawing controls

#if !defined(__DWGCTRL_H__)
#define __DWGCTRL_H__

struct drawingStandards
{
	// Drawing Standards
	short m_nPinNameOffset;
	bool m_bShowCrossPageRefs;
	bool m_bShowConnectDots;
	bool m_bMarkOpenEnds;
	bool m_bShowBorder;
	bool m_bRotPinNumbers;
	bool m_bRotNetNames;
	// Sheet Sizing
	short m_nHorzZones;
	short m_nVertZones;
	bool m_bAlphaVertZones;
	short m_nGrid;
	short m_nMetric;
	drawingStandards();
};

extern drawingStandards theDrawingStandards;

// Drawing Standards
// CTL_PinNameOffset used by listsym, can be eliminated
#define CTL_PinNameOffset			theDrawingStandards.m_nPinNameOffset
#define CTL_ShowCrossPageRefs		theDrawingStandards.m_bShowCrossPageRefs
#define CTL_ShowConnectDots 		theDrawingStandards.m_bShowConnectDots
#define CTL_MarkOpenEnds			theDrawingStandards.m_bMarkOpenEnds
#define CTL_ShowBorder				theDrawingStandards.m_bShowBorder
// CTL_RotPinNumbers used by EDIFOUT
#define CTL_RotPinNumbers			theDrawingStandards.m_bRotPinNumbers
#define CTL_RotNetNames 			theDrawingStandards.m_bRotNetNames
// Sheet Sizing
#define CTL_HorzZones				theDrawingStandards.m_nHorzZones
#define CTL_VertZones				theDrawingStandards.m_nVertZones
#define CTL_AlphaVertZones			theDrawingStandards.m_bAlphaVertZones
// CTL_Grid used by EDIFIN, EDIFOUT
#define CTL_Grid					theDrawingStandards.m_nGrid
#define CTL_Metric					theDrawingStandards.m_nMetric

#endif	// __DWGCTRL_H__
