/***************************************************************************************************/
/*                                                                                                 */
/* file:          config.h                                                                         */
/*                                                                                                 */
/* source:        2018-2020, written by Adrian Kundert (adrian.kundert@gmail.com)                  */
/*                                                                                                 */
/* description:																		               */
/*                                                                                                 */
/* This library is free software; you can redistribute it and/or modify it under the terms of the  */
/* GNU Lesser General Public License as published by the Free Software Foundation;                 */
/* either version 2.1 of the License, or (at your option) any later version.                       */
/*                                                                                                 */
/* This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;       */
/* without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.       */
/* See the GNU Lesser General Public License for more details.                                     */
/*                                                                                                 */
/***************************************************************************************************/

#ifndef config_h
#define config_h

//================================ Hardware Config (begin) ========================================//
#define F_CPU 32000000UL  // system clock

// Note:  print tile on screen command is not yet implemented for no HwMux
#define PIXEL_HW_MUX      // this define enables the Pixel Hardware Mux

//#define NO_XSCROLLING		// use this define to disable the x scrolling feature in GraphMode (1 tile resolution could increased)
//================================ Hardware Config (end) ==========================================//

#endif

