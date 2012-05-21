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
//    Jia Haipeng, jiahaipeng95@gmail.com
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
//   * Redistribution's of source code must retain the above copyright notice,
//     this list of conditions and the following disclaimer.
//
//   * Redistribution's in binary form must reproduce the above copyright notice,
//     this list of conditions and the following disclaimer in the documentation
//     and/or other oclMaterials provided with the distribution.
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

#if defined (__ATI__)
#pragma OPENCL EXTENSION cl_amd_fp64:enable
#elif defined (__NVIDIA__)
#pragma OPENCL EXTENSION cl_khr_fp64:enable
#endif

//////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////addWeighted//////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
__kernel void addWeighted_D0(__global uchar *src1, double alpha, int src1_step, int src1_offset,
                             __global uchar *src2, double beta, int src2_step, int src2_offset,
                             double gama,
                             __global uchar *dst,  int dst_step, int dst_offset,
                             int rows,  int cols, int dst_step1)
{
	int x = get_global_id(0);
	int y = get_global_id(1);
	
	if (x < cols && y < rows)
	
	{
	
		x = x << 2;
		
#define dst_align (dst_offset & 3)
		int src1_index = mad24(y, src1_step, x + src1_offset - dst_align);
		int src2_index = mad24(y, src2_step, x + src2_offset - dst_align);
		
		int dst_start  = mad24(y, dst_step, dst_offset);
		int dst_end    = mad24(y, dst_step, dst_offset + dst_step1);
		int dst_index  = mad24(y, dst_step, dst_offset + x & (int)0xfffffffc);
		
		uchar4 src1_data = vload4(0, src1 + src1_index);
		uchar4 src2_data = vload4(0, src2 + src2_index);
		
		uchar4 dst_data = *((__global uchar4 *)(dst + dst_index));
		short4 tmp      = convert_short4_sat(src1_data) * alpha + convert_short4_sat(src2_data) * beta + gama;
		uchar4 tmp_data = convert_uchar4_sat(tmp);
		
		dst_data.x = ((dst_index + 0 >= dst_start) && (dst_index + 0 < dst_end)) ? tmp_data.x : dst_data.x;
		dst_data.y = ((dst_index + 1 >= dst_start) && (dst_index + 1 < dst_end)) ? tmp_data.y : dst_data.y;
		dst_data.z = ((dst_index + 2 >= dst_start) && (dst_index + 2 < dst_end)) ? tmp_data.z : dst_data.z;
		dst_data.w = ((dst_index + 3 >= dst_start) && (dst_index + 3 < dst_end)) ? tmp_data.w : dst_data.w;
		
		*((__global uchar4 *)(dst + dst_index)) = dst_data;
		// dst[x + y * dst_step] = src1[x + y * src1_step] * alpha + src2[x + y * src2_step] * beta + gama;
	}
	
}



__kernel void addWeighted_D2(__global ushort *src1, double alpha, int src1_step, int src1_offset,
                             __global ushort *src2, double beta, int src2_step, int src2_offset,
                             double gama,
                             __global ushort *dst,  int dst_step, int dst_offset,
                             int rows,  int cols, int dst_step1)
{
	int x = get_global_id(0);
	int y = get_global_id(1);
	
	if (x < cols && y < rows)
	
	{
	
		x = x << 2;
		
#define dst_align ((dst_offset >> 1) & 3)
		int src1_index = mad24(y, src1_step, (x << 1) + src1_offset - (dst_align << 1));
		int src2_index = mad24(y, src2_step, (x << 1) + src2_offset - (dst_align << 1));
		
		int dst_start  = mad24(y, dst_step, dst_offset);
		int dst_end    = mad24(y, dst_step, dst_offset + dst_step1);
		int dst_index  = mad24(y, dst_step, dst_offset + (x << 1) & (int)0xfffffff8);
		
		ushort4 src1_data = vload4(0, (__global ushort *)((__global char *)src1 + src1_index));
		ushort4 src2_data = vload4(0, (__global ushort *)((__global char *)src2 + src2_index));
		
		ushort4 dst_data = *((__global ushort4 *)((__global char *)dst + dst_index));
		int4 tmp      = convert_int4_sat(src1_data) * alpha + convert_int4_sat(src2_data) * beta + gama;
		ushort4 tmp_data = convert_ushort4_sat(tmp);
		dst_data.x = ((dst_index + 0 >= dst_start) && (dst_index + 0 < dst_end)) ? tmp_data.x : dst_data.x;
		dst_data.y = ((dst_index + 2 >= dst_start) && (dst_index + 2 < dst_end)) ? tmp_data.y : dst_data.y;
		dst_data.z = ((dst_index + 4 >= dst_start) && (dst_index + 4 < dst_end)) ? tmp_data.z : dst_data.z;
		dst_data.w = ((dst_index + 6 >= dst_start) && (dst_index + 6 < dst_end)) ? tmp_data.w : dst_data.w;
		
		*((__global ushort4 *)((__global char *)dst + dst_index)) = dst_data;
	}
	
	
}


__kernel void addWeighted_D3(__global short *src1, double alpha, int src1_step, int src1_offset,
                             __global short *src2, double beta, int src2_step, int src2_offset,
                             double gama,
                             __global short *dst,  int dst_step, int dst_offset,
                             int rows,  int cols, int dst_step1)
{
	int x = get_global_id(0);
	int y = get_global_id(1);
	
	if (x < cols && y < rows)
	
	{
	
		x = x << 2;
		
#define dst_align ((dst_offset >> 1) & 3)
		int src1_index = mad24(y, src1_step, (x << 1) + src1_offset - (dst_align << 1));
		int src2_index = mad24(y, src2_step, (x << 1) + src2_offset - (dst_align << 1));
		
		int dst_start  = mad24(y, dst_step, dst_offset);
		int dst_end    = mad24(y, dst_step, dst_offset + dst_step1);
		int dst_index  = mad24(y, dst_step, dst_offset + (x << 1) - (dst_align << 1));
		
		short4 src1_data = vload4(0, (__global short *)((__global char *)src1 + src1_index));
		short4 src2_data = vload4(0, (__global short *)((__global char *)src2 + src2_index));
		
		short4 dst_data = *((__global short4 *)((__global char *)dst + dst_index));
		int4 tmp      = convert_int4_sat(src1_data) * alpha + convert_int4_sat(src2_data) * beta + gama;
		short4 tmp_data = convert_short4_sat(tmp);
		dst_data.x = ((dst_index + 0 >= dst_start) && (dst_index + 0 < dst_end)) ? tmp_data.x : dst_data.x;
		dst_data.y = ((dst_index + 2 >= dst_start) && (dst_index + 2 < dst_end)) ? tmp_data.y : dst_data.y;
		dst_data.z = ((dst_index + 4 >= dst_start) && (dst_index + 4 < dst_end)) ? tmp_data.z : dst_data.z;
		dst_data.w = ((dst_index + 6 >= dst_start) && (dst_index + 6 < dst_end)) ? tmp_data.w : dst_data.w;
		
		*((__global short4 *)((__global char *)dst + dst_index)) = dst_data;
	}
	
}


__kernel void addWeighted_D4(__global int *src1, double alpha, int src1_step, int src1_offset,
                             __global int *src2, double beta, int src2_step, int src2_offset,
                             double gama,
                             __global int *dst,  int dst_step, int dst_offset,
                             int rows,  int cols, int dst_step1)
{
	int x = get_global_id(0);
	int y = get_global_id(1);
	
	if (x < cols && y < rows)
	
	{
	
		x = x << 2;
		
#define bitOfInt  (sizeof(int)== 4 ? 2: 3)
		
#define dst_align ((dst_offset >> bitOfInt) & 3)
		
		int src1_index = mad24(y, src1_step, (x << bitOfInt) + src1_offset - (dst_align << bitOfInt));
		int src2_index = mad24(y, src2_step, (x << bitOfInt) + src2_offset - (dst_align << bitOfInt));
		
		int dst_start  = mad24(y, dst_step, dst_offset);
		int dst_end    = mad24(y, dst_step, dst_offset + dst_step1);
		int dst_index  = mad24(y, dst_step, dst_offset + (x << bitOfInt) - (dst_align << bitOfInt));
		
		int4 src1_data = vload4(0, (__global int *)((__global char *)src1 + src1_index));
		int4 src2_data = vload4(0, (__global int *)((__global char *)src2 + src2_index));
		int4 dst_data = *((__global int4 *)((__global char *)dst + dst_index));
		double4   tmp = convert_double4(src1_data) * alpha + convert_double4(src2_data) * beta + gama ;
		int4 tmp_data = convert_int4_sat(tmp);
		
		dst_data.x = ((dst_index + 0 >= dst_start) && (dst_index + 0 < dst_end)) ? tmp_data.x : dst_data.x;
		dst_data.y = ((dst_index + 4 >= dst_start) && (dst_index + 4 < dst_end)) ? tmp_data.y : dst_data.y;
		dst_data.z = ((dst_index + 8 >= dst_start) && (dst_index + 8 < dst_end)) ? tmp_data.z : dst_data.z;
		dst_data.w = ((dst_index + 12 >= dst_start) && (dst_index + 12 < dst_end)) ? tmp_data.w : dst_data.w;
		
		*((__global int4 *)((__global char *)dst + dst_index)) = dst_data;
	}
	
}


__kernel void addWeighted_D5(__global float *src1, double alpha, int src1_step, int src1_offset,
                             __global float *src2, double beta, int src2_step, int src2_offset,
                             double gama,
                             __global float *dst,  int dst_step, int dst_offset,
                             int rows,  int cols, int dst_step1)
{
	int x = get_global_id(0);
	int y = get_global_id(1);
	
	if (x < cols && y < rows)
	
	{
	
		x = x << 2;
		
#define dst_align ((dst_offset >> 2) & 3)
		
		int src1_index = mad24(y, src1_step, (x << 2) + src1_offset - (dst_align << 2));
		int src2_index = mad24(y, src2_step, (x << 2) + src2_offset - (dst_align << 2));
		
		int dst_start  = mad24(y, dst_step, dst_offset);
		int dst_end    = mad24(y, dst_step, dst_offset + dst_step1);
		int dst_index  = mad24(y, dst_step, dst_offset + (x << 2) - (dst_align << 2));
		
		float4 src1_data = vload4(0, (__global float *)((__global char *)src1 + src1_index));
		float4 src2_data = vload4(0, (__global float *)((__global char *)src2 + src2_index));
		float4 dst_data = *((__global float4 *)((__global char *)dst + dst_index));
		//    double4   tmp = convert_double4(src1_data) * alpha + convert_double4(src2_data) * beta + gama ;
		
		float4   tmp_data = (src1_data) * alpha + (src2_data) * beta + gama ;
		// float4 tmp_data = convert_float4(tmp);
		
		dst_data.x = ((dst_index + 0 >= dst_start) && (dst_index + 0 < dst_end)) ? tmp_data.x : dst_data.x;
		dst_data.y = ((dst_index + 4 >= dst_start) && (dst_index + 4 < dst_end)) ? tmp_data.y : dst_data.y;
		dst_data.z = ((dst_index + 8 >= dst_start) && (dst_index + 8 < dst_end)) ? tmp_data.z : dst_data.z;
		dst_data.w = ((dst_index + 12 >= dst_start) && (dst_index + 12 < dst_end)) ? tmp_data.w : dst_data.w;
		
		*((__global float4 *)((__global char *)dst + dst_index)) = dst_data;
	}
	
}


__kernel void addWeighted_D6(__global double *src1, double alpha, int src1_step, int src1_offset,
                             __global double *src2, double beta, int src2_step, int src2_offset,
                             double gama,
                             __global double *dst,  int dst_step, int dst_offset,
                             int rows,  int cols, int dst_step1)
{
	int x = get_global_id(0);
	int y = get_global_id(1);
	
	if (x < cols && y < rows)
	
	{
	
		x = x << 2;
		
#define dst_align ((dst_offset >> 3) & 3)
		
		int src1_index = mad24(y, src1_step, (x << 3) + src1_offset - (dst_align << 3));
		int src2_index = mad24(y, src2_step, (x << 3) + src2_offset - (dst_align << 3));
		
		int dst_start  = mad24(y, dst_step, dst_offset);
		int dst_end    = mad24(y, dst_step, dst_offset + dst_step1);
		int dst_index  = mad24(y, dst_step, dst_offset + (x << 3) - (dst_align << 3));
		
		double4 src1_data = vload4(0, (__global double *)((__global char *)src1 + src1_index));
		double4 src2_data = vload4(0, (__global double *)((__global char *)src2 + src2_index));
		double4 dst_data = *((__global double4 *)((__global char *)dst + dst_index));
		double4   tmp_data = (src1_data) * alpha + (src2_data) * beta + gama ;
		
		dst_data.x = ((dst_index + 0 >= dst_start) && (dst_index + 0 < dst_end)) ? tmp_data.x : dst_data.x;
		dst_data.y = ((dst_index + 8 >= dst_start) && (dst_index + 8 < dst_end)) ? tmp_data.y : dst_data.y;
		dst_data.z = ((dst_index + 16 >= dst_start) && (dst_index + 16 < dst_end)) ? tmp_data.z : dst_data.z;
		dst_data.w = ((dst_index + 24 >= dst_start) && (dst_index + 24 < dst_end)) ? tmp_data.w : dst_data.w;
		
		*((__global double4 *)((__global char *)dst + dst_index)) = dst_data;
	}
	
}