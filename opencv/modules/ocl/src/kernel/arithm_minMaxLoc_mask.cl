/*M///////////////////////////////////////////////////////////////////////////////////////
//
//  IMPORTANT: READ BEFORE DOWNLOADING, COPYING, INSTALLING OR USING.
//
//  By downloading, copying, installing or using the software you agree to this license.
//  If you do not agree to this license, do not download, install,
//  copy or use the software.
//
//
//                           License Agreement
//                For Open Source Computer Vision Library
//
// Copyright (C) 2010-2012, Institute Of Software Chinese Academy Of Science, all rights reserved.
// Copyright (C) 2010-2012, Advanced Micro Devices, Inc., all rights reserved.
// Third party copyrights are property of their respective owners.
//
// @Authors
//    Shengen Yan, yanshengen@gmail.com
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
//   * Redistribution's of source code must retain the above copyright notice,
//     this list of conditions and the following disclaimer.
//
//   * Redistribution's in binary form must reproduce the above copyright notice,
//     this list of conditions and the following disclaimer in the documentation
//     and/or other GpuMaterials provided with the distribution.
//
//   * The name of the copyright holders may not be used to endorse or promote products
//     derived from this software without specific prior written permission.
//
// This software is provided by the copyright holders and contributors as is and
// any express or implied warranties, including, but not limited to, the implied
// warranties of merchantability and fitness for a particular purpose are disclaimed.
// In no event shall the Intel Corporation or contributors be liable for any direct,
// indirect, incidental, special, exemplary, or consequential damages
// (including, but not limited to, procurement of substitute goods or services;
// loss of use, data, or profits; or business interruption) however caused
// and on any theory of liability, whether in contract, strict liability,
// or tort (including negligence or otherwise) arising in any way out of
// the use of this software, even if advised of the possibility of such damage.
//
//M*/

/**************************************PUBLICFUNC*************************************/
#if defined (__ATI__)
#pragma OPENCL EXTENSION cl_amd_fp64:enable
#elif defined (__NVIDIA__)
#pragma OPENCL EXTENSION cl_khr_fp64:enable
#endif

#if defined (DEPTH_0)
#define TYPE uchar
#define VEC_TYPE uchar8
#define VEC_TYPE_LOC int8
#define CONVERT_TYPE convert_uchar8
#define CONDITION_FUNC(a,b,c) (convert_int8(a) ? b : c)
#define MIN_VAL 0
#define MAX_VAL 255
#endif
#if defined (DEPTH_1)
#define TYPE char
#define VEC_TYPE char8
#define VEC_TYPE_LOC int8
#define CONVERT_TYPE convert_char8
#define CONDITION_FUNC(a,b,c) (convert_int8(a) ? b : c)
#define MIN_VAL -128
#define MAX_VAL 127
#endif
#if defined (DEPTH_2)
#define TYPE ushort
#define VEC_TYPE ushort8
#define VEC_TYPE_LOC int8
#define CONVERT_TYPE convert_ushort8
#define CONDITION_FUNC(a,b,c) (convert_int8(a) ? b : c)
#define MIN_VAL 0
#define MAX_VAL 65535
#endif
#if defined (DEPTH_3)
#define TYPE short
#define VEC_TYPE short8
#define VEC_TYPE_LOC int8
#define CONVERT_TYPE convert_short8
#define CONDITION_FUNC(a,b,c) (convert_int8(a) ? b : c)
#define MIN_VAL -32768
#define MAX_VAL 32767
#endif
#if defined (DEPTH_4)
#define TYPE int
#define VEC_TYPE int8
#define VEC_TYPE_LOC int8
#define CONVERT_TYPE convert_int8
#define CONDITION_FUNC(a,b,c) ((a) ? b : c)
#define MIN_VAL INT_MIN
#define MAX_VAL INT_MAX
#endif
#if defined (DEPTH_5)
#define TYPE float
#define VEC_TYPE float8
#define VEC_TYPE_LOC float8
#define CONVERT_TYPE convert_float8
#define CONDITION_FUNC(a,b,c) ((a) ? b : c)
#define MIN_VAL (-FLT_MAX)
#define MAX_VAL FLT_MAX
#endif
#if defined (DEPTH_6)
#define TYPE double
#define VEC_TYPE double8
#define VEC_TYPE_LOC double8
#define CONVERT_TYPE convert_double8
#define CONDITION_FUNC(a,b,c) ((a) ? b : c)
#define MIN_VAL (-DBL_MAX)
#define MAX_VAL DBL_MAX
#endif

#if defined (REPEAT_E0)
#define repeat_e(a) a = a;
#endif
#if defined (REPEAT_E1)
#define repeat_e(a) a.s7 = a.s6;
#endif
#if defined (REPEAT_E2)
#define repeat_e(a) a.s7 = a.s5;a.s6 = a.s5;
#endif
#if defined (REPEAT_E3)
#define repeat_e(a) a.s7 = a.s4;a.s6 = a.s4;a.s5 = a.s4;
#endif
#if defined (REPEAT_E4)
#define repeat_e(a) a.s7 = a.s3;a.s6 = a.s3;a.s5 = a.s3;a.s4 = a.s3;
#endif
#if defined (REPEAT_E5)
#define repeat_e(a) a.s7 = a.s2;a.s6 = a.s2;a.s5 = a.s2;a.s4 = a.s2;a.s3 = a.s2;
#endif
#if defined (REPEAT_E6)
#define repeat_e(a) a.s7 = a.s1;a.s6 = a.s1;a.s5 = a.s1;a.s4 = a.s1;a.s3 = a.s1;a.s2 = a.s1;
#endif
#if defined (REPEAT_E7)
#define repeat_e(a) a.s7 = a.s0;a.s6 = a.s0;a.s5 = a.s0;a.s4 = a.s0;a.s3 = a.s0;a.s2 = a.s0;a.s1 = a.s0;
#endif

#if defined (REPEAT_E0)
#define repeat_me(a) a = a;
#endif
#if defined (REPEAT_E1)
#define repeat_me(a) a.s7 = 0;
#endif
#if defined (REPEAT_E2)
#define repeat_me(a) a.s7 = 0;a.s6 = 0;
#endif
#if defined (REPEAT_E3)
#define repeat_me(a) a.s7 = 0;a.s6 = 0;a.s5 = 0;
#endif
#if defined (REPEAT_E4)
#define repeat_me(a) a.s7 = 0;a.s6 = 0;a.s5 = 0;a.s4 = 0;
#endif
#if defined (REPEAT_E5)
#define repeat_me(a) a.s7 = 0;a.s6 = 0;a.s5 = 0;a.s4 = 0;a.s3 = 0;
#endif
#if defined (REPEAT_E6)
#define repeat_me(a) a.s7 = 0;a.s6 = 0;a.s5 = 0;a.s4 = 0;a.s3 = 0;a.s2 = 0;
#endif
#if defined (REPEAT_E7)
#define repeat_me(a) a.s7 = 0;a.s6 = 0;a.s5 = 0;a.s4 = 0;a.s3 = 0;a.s2 = 0;a.s1 = 0;
#endif

/**************************************Array minMax mask**************************************/
__kernel void arithm_op_minMaxLoc_mask(int cols, int invalid_cols, int offset, int elemnum, int groupnum, __global TYPE *src,
                                       int minvalid_cols, int moffset, __global uchar *mask, __global double8  *dst)
{
	unsigned int lid = get_local_id(0);
	unsigned int gid = get_group_id(0);
	unsigned int  id = get_global_id(0);
	unsigned int idx = id + (id / cols) * invalid_cols;
	unsigned int midx = id + (id / cols) * minvalid_cols;
	__local VEC_TYPE lm_max[128], lm_min[128];
	VEC_TYPE minval, maxval, temp, m_temp;
	__local VEC_TYPE_LOC lm_maxloc[128], lm_minloc[128];
	VEC_TYPE_LOC minloc, maxloc, temploc, negative = -1, one = 1, zero = 0;
	
	if (id < elemnum)
	{
		temp = vload8(idx, &src[offset]);
		m_temp = CONVERT_TYPE(vload8(midx, &mask[moffset]));
		int idx_c = (idx << 3) + offset;
		temploc = (VEC_TYPE_LOC)(idx_c, idx_c + 1, idx_c + 2, idx_c + 3, idx_c + 4, idx_c + 5, idx_c + 6, idx_c + 7);
		
		if (id % cols == cols - 1)
		{
			repeat_me(m_temp);
			repeat_e(temploc);
		}
		
		minval = m_temp != 0 ? temp : MAX_VAL;
		maxval = m_temp != 0 ? temp : MIN_VAL;
		minloc = CONDITION_FUNC(m_temp != 0, temploc , negative);
		maxloc = minloc;
	}
	else
	{
		minval = MAX_VAL;
		maxval = MIN_VAL;
		minloc = negative;
		maxloc = negative;
	}
	
	for (id = id + (groupnum << 8); id < elemnum; id = id + (groupnum << 8))
	{
		idx = id + (id / cols) * invalid_cols;
		midx = id + (id / cols) * minvalid_cols;
		temp = vload8(idx, &src[offset]);
		m_temp = CONVERT_TYPE(vload8(midx, &mask[moffset]));
		int idx_c = (idx << 3) + offset;
		temploc = (VEC_TYPE_LOC)(idx_c, idx_c + 1, idx_c + 2, idx_c + 3, idx_c + 4, idx_c + 5, idx_c + 6, idx_c + 7);
		
		if (id % cols == cols - 1)
		{
			repeat_me(m_temp);
			repeat_e(temploc);
		}
		
		minval = min(minval, m_temp != 0 ? temp : minval);
		maxval = max(maxval, m_temp != 0 ? temp : maxval);
		
		minloc = CONDITION_FUNC((minval == temp) && (m_temp != 0), temploc , minloc);
		maxloc = CONDITION_FUNC((maxval == temp) && (m_temp != 0), temploc , maxloc);
	}
	
	if (lid > 127)
	{
		lm_min[lid - 128] = minval;
		lm_max[lid - 128] = maxval;
		lm_minloc[lid - 128] = minloc;
		lm_maxloc[lid - 128] = maxloc;
	}
	
	barrier(CLK_LOCAL_MEM_FENCE);
	
	if (lid < 128)
	{
		lm_min[lid] = min(minval, lm_min[lid]);
		lm_max[lid] = max(maxval, lm_max[lid]);
		VEC_TYPE con_min = CONVERT_TYPE(minloc != negative ? one : zero);
		VEC_TYPE con_max = CONVERT_TYPE(maxloc != negative ? one : zero);
		lm_minloc[lid] = CONDITION_FUNC((lm_min[lid] == minval) && (con_min != 0), minloc , lm_minloc[lid]);
		lm_maxloc[lid] = CONDITION_FUNC((lm_max[lid] == maxval) && (con_max != 0), maxloc , lm_maxloc[lid]);
	}
	
	barrier(CLK_LOCAL_MEM_FENCE);
	
	for (int lsize = 64; lsize > 0; lsize >>= 1)
	{
		if (lid < lsize)
		{
			int lid2 = lsize + lid;
			lm_min[lid] = min(lm_min[lid] , lm_min[lid2]);
			lm_max[lid] = max(lm_max[lid] , lm_max[lid2]);
			VEC_TYPE con_min = CONVERT_TYPE(lm_minloc[lid2] != negative ? one : zero);
			VEC_TYPE con_max = CONVERT_TYPE(lm_maxloc[lid2] != negative ? one : zero);
			lm_minloc[lid] =
			    CONDITION_FUNC((lm_min[lid] == lm_min[lid2]) && (con_min != 0), lm_minloc[lid2] , lm_minloc[lid]);
			lm_maxloc[lid] =
			    CONDITION_FUNC((lm_max[lid] == lm_max[lid2]) && (con_max != 0), lm_maxloc[lid2] , lm_maxloc[lid]);
		}
		
		barrier(CLK_LOCAL_MEM_FENCE);
	}
	
	if (lid == 0)
	{
		dst[gid] = convert_double8(lm_min[0]);
		dst[gid + groupnum] = convert_double8(lm_max[0]);
		dst[gid + 2 * groupnum] = convert_double8(lm_minloc[0]);
		dst[gid + 3 * groupnum] = convert_double8(lm_maxloc[0]);
	}
}
