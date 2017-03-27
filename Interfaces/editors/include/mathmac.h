/* mathmac.h - math functions */

/* Copyright (C) 1993 -- Data I/O Corporation -- All Rights Reserved.
 *
 * This program is protected under the copyright laws as a published work.
 * It may not be copied, reproduced, further distributed, adaptations
 * made from the same, or used to prepare derivative works, without the
 * prior written consent of the Data I/O Corporation
 *
 * History:
 *    5/05/93 - Included in Version 2.5
 */

int ClipLine( int x1, int y1, int x2, int y2,
              int left, int top, int right, int bottom );
int Rsin( int rad, int ang );
int LineLength( int x, int y );
int Angle( int x, int y );

/*** Geometric Macros assume y grows downward ***/
#define DISTANCE( xy1, xy2 ) LineLength( xy1.x - xy2.x, xy2.y - xy1.y )
#define ANGLE_AT( xy1, xy2 ) Angle( xy1.x - xy2.x, xy2.y - xy1.y )
#define LINE_LENGTH( x, y ) LineLength( x, y )

#define RECT_TO_POLAR( x, y, r, a ) \
 { *a= Angle( x, -y ); *r= LineLength( x, y ); }
#define POLAR_TO_RECT( r, a, x, y ) { *x= Rsin( r, 90-a ); *y= -Rsin( r, a ); }

/*** Macros for Graphics Picking ***/
#define POINT_IN_BOX( xy ) \
   ( xy.x >= box.left && xy.x <= box.right && \
     xy.y >= box.top  && xy.y <= box.bottom )
#define RECT_HITS_BOX( rect ) ( RECT_INTERSECTS_BOX( rect ) && \
   ( rect.right <= box.right  || rect.left   >= box.left || \
     rect.top   >= box.top    || rect.bottom <= box.bottom ) )
#define RECT_IN_BOX( rect ) \
   ( rect.left >= box.left && rect.right  <= box.right && \
     rect.top  >= box.top  && rect.bottom <= box.bottom )
#define RECT_INTERSECTS_BOX( rect ) \
   ( rect.left <= box.right  && rect.right  >= box.left && \
     rect.top  <= box.bottom && rect.bottom >= box.top )
#define LINE_HITS_BOX( xy1, xy2 ) \
   ( ClipLine( xy1.x, xy1.y, xy2.x, xy2.y, \
               box.left, box.top, box.right, box.bottom ) )
