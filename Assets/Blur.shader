// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Blur"
{
	Properties
	{
		_MainTex("_MainTex", 2D) = "white" {}
		_A_SmokyFaceMask("A_SmokyFaceMask", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		

		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		

		
		Pass
		{
			Name "Unlit"

			CGPROGRAM

			#define ASE_VERSION 19801
			#define ASE_USING_SAMPLING_MACROS 1


			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
			#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
			#define SAMPLE_TEXTURE2D_LOD(tex,samplerTex,coord,lod) tex.SampleLevel(samplerTex,coord, lod)
			#else//ASE Sampling Macros
			#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
			#define SAMPLE_TEXTURE2D_LOD(tex,samplerTex,coord,lod) tex2Dlod(tex,float4(coord,0,lod))
			#endif//ASE Sampling Macros
			


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			UNITY_DECLARE_TEX2D_NOSAMPLER(_RGBFace);
			SamplerState sampler_Trilinear_Clamp_Aniso16;
			UNITY_DECLARE_TEX2D_NOSAMPLER(_A_SmokyFaceMask);
			uniform float4 _A_SmokyFaceMask_ST;
			SamplerState sampler_A_SmokyFaceMask;
			UNITY_DECLARE_TEX2D_NOSAMPLER(_MainTex);
			SamplerState sampler_MainTex;


			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}

			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 texCoord4 = i.ase_texcoord1.xy * float2( 0.9,1 ) + float2( 0.05,0 );
				float2 texCoord58 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_59_0 = saturate( ( pow( ( 1.0 - texCoord58.y ) , 1.5 ) * 0.016 ) );
				float2 appendResult44 = (float2(temp_output_59_0 , 0.0));
				float2 texCoord6 = i.ase_texcoord1.xy * float2( 0.9,1 ) + ( appendResult44 + float2( 0.05,0 ) );
				float2 appendResult45 = (float2(temp_output_59_0 , 0.0));
				float2 texCoord9 = i.ase_texcoord1.xy * float2( 0.9,1 ) + ( appendResult45 + float2( 0.05,0 ) );
				float temp_output_52_0 = ( temp_output_59_0 * -1.0 );
				float2 appendResult46 = (float2(temp_output_52_0 , 0.0));
				float2 texCoord12 = i.ase_texcoord1.xy * float2( 0.9,1 ) + ( appendResult46 + float2( 0.05,0 ) );
				float2 appendResult47 = (float2(0.0 , temp_output_52_0));
				float2 texCoord15 = i.ase_texcoord1.xy * float2( 0.9,1 ) + ( appendResult47 + float2( 0.05,0 ) );
				float2 appendResult48 = (float2(temp_output_52_0 , temp_output_59_0));
				float2 texCoord18 = i.ase_texcoord1.xy * float2( 0.9,1 ) + ( appendResult48 + float2( 0.05,0 ) );
				float2 appendResult49 = (float2(temp_output_59_0 , temp_output_59_0));
				float2 texCoord21 = i.ase_texcoord1.xy * float2( 0.9,1 ) + ( appendResult49 + float2( 0.05,0 ) );
				float2 appendResult50 = (float2(temp_output_52_0 , temp_output_52_0));
				float2 texCoord24 = i.ase_texcoord1.xy * float2( 0.9,1 ) + ( appendResult50 + float2( 0.05,0 ) );
				float2 appendResult51 = (float2(temp_output_59_0 , temp_output_52_0));
				float2 texCoord27 = i.ase_texcoord1.xy * float2( 0.9,1 ) + ( appendResult51 + float2( 0.05,0 ) );
				float2 uv_A_SmokyFaceMask = i.ase_texcoord1.xy * _A_SmokyFaceMask_ST.xy + _A_SmokyFaceMask_ST.zw;
				float2 texCoord73 = i.ase_texcoord1.xy * float2( 0.9,1 ) + float2( 0.05,0 );
				float4 appendResult55 = (float4(saturate( ( ( ( SAMPLE_TEXTURE2D_LOD( _RGBFace, sampler_Trilinear_Clamp_Aniso16, texCoord4, 0.0 ).rgb + SAMPLE_TEXTURE2D_LOD( _RGBFace, sampler_Trilinear_Clamp_Aniso16, texCoord6, 0.0 ).rgb + SAMPLE_TEXTURE2D_LOD( _RGBFace, sampler_Trilinear_Clamp_Aniso16, texCoord9, 0.0 ).rgb + SAMPLE_TEXTURE2D_LOD( _RGBFace, sampler_Trilinear_Clamp_Aniso16, texCoord12, 0.0 ).rgb + SAMPLE_TEXTURE2D_LOD( _RGBFace, sampler_Trilinear_Clamp_Aniso16, texCoord15, 0.0 ).rgb + SAMPLE_TEXTURE2D_LOD( _RGBFace, sampler_Trilinear_Clamp_Aniso16, texCoord18, 0.0 ).rgb + SAMPLE_TEXTURE2D_LOD( _RGBFace, sampler_Trilinear_Clamp_Aniso16, texCoord21, 0.0 ).rgb + SAMPLE_TEXTURE2D_LOD( _RGBFace, sampler_Trilinear_Clamp_Aniso16, texCoord24, 0.0 ).rgb + SAMPLE_TEXTURE2D_LOD( _RGBFace, sampler_Trilinear_Clamp_Aniso16, texCoord27, 0.0 ).rgb ) / float3(9,9,9) ) + SAMPLE_TEXTURE2D( _A_SmokyFaceMask, sampler_A_SmokyFaceMask, uv_A_SmokyFaceMask ).rgb ) ) , pow( SAMPLE_TEXTURE2D_LOD( _MainTex, sampler_MainTex, texCoord73, 0.0 ).r , 1.25 )));
				

				finalColor = appendResult55;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19801
Node;AmplifyShaderEditor.TextureCoordinatesNode;58;-2544,400;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;60;-2320,464;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;65;-2160,448;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-1984,464;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.016;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;59;-1776,464;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-1280,624;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;44;-864,208;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;45;-848,432;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;47;-806.5229,890.824;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;48;-787.7189,1165.651;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;49;-794.9512,1303.064;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;50;-768,1488;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;51;-761.6826,1683.483;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;46;-813.7552,656.4978;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;74;-720,96;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.05,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;75;-704,448;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.05,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;-673.199,774.5627;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.05,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;77;-688,976;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.05,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;78;-640,1216;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.05,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;79;-656,1376;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.05,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;80;-640,1584;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.05,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;81;-688,1808;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.05,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerStateNode;10;-576,512;Inherit;False;1;1;1;2;-1;X16;1;0;SAMPLER2D;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.SamplerStateNode;13;-576,720;Inherit;False;1;1;1;2;-1;X16;1;0;SAMPLER2D;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.SamplerStateNode;16;-560,928;Inherit;False;1;1;1;2;-1;X16;1;0;SAMPLER2D;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.SamplerStateNode;19;-560,1136;Inherit;False;1;1;1;2;-1;X16;1;0;SAMPLER2D;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.SamplerStateNode;22;-544,1344;Inherit;False;1;1;1;2;-1;X16;1;0;SAMPLER2D;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.SamplerStateNode;25;-544,1568;Inherit;False;1;1;1;2;-1;X16;1;0;SAMPLER2D;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.SamplerStateNode;28;-560,1776;Inherit;False;1;1;1;2;-1;X16;1;0;SAMPLER2D;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.SamplerStateNode;5;-576,96;Inherit;False;1;1;1;2;-1;X16;1;0;SAMPLER2D;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.SamplerStateNode;7;-576,304;Inherit;False;1;1;1;2;-1;X16;1;0;SAMPLER2D;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.TexturePropertyNode;2;-544,1920;Inherit;True;Global;_RGBFace;_RGBFace;0;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;27;-576,1664;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.9,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-560,1456;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.9,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-560,1232;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.9,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-576,1024;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.9,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-576,816;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.9,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-592,608;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.9,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-592,400;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.9,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-592,192;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.9,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-592,-16;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.9,1;False;1;FLOAT2;0.05,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;8;-240,128;Inherit;True;Property;_TextureSample1;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;11;-240,336;Inherit;True;Property;_TextureSample2;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;14;-240,544;Inherit;True;Property;_TextureSample3;Texture Sample 0;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;17;-224,752;Inherit;True;Property;_TextureSample4;Texture Sample 0;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;20;-224,960;Inherit;True;Property;_TextureSample5;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;23;-208,1168;Inherit;True;Property;_TextureSample6;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;26;-208,1392;Inherit;True;Property;_TextureSample7;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;3;-240,-80;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;29;-224,1600;Inherit;True;Property;_TextureSample8;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleAddOpNode;53;336,528;Inherit;False;9;9;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;54;400,896;Inherit;False;Constant;_Vector1;Vector 1;2;0;Create;True;0;0;0;False;0;False;9,9,9;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;73;496,1200;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.9,1;False;1;FLOAT2;0.05,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;41;592,672;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;62;496,304;Inherit;True;Property;_A_SmokyFaceMask;A_SmokyFaceMask;2;0;Create;True;0;0;0;False;0;False;-1;273c4e952b4fe9e44a0faf3e8ab282f4;273c4e952b4fe9e44a0faf3e8ab282f4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;57;752,896;Inherit;True;Property;_MainTex;_MainTex;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleAddOpNode;66;816,608;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;67;1045.614,519.9894;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;72;1168,896;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1856,640;Inherit;True;Constant;_BlurSize;Blur Size;1;0;Create;True;0;0;0;False;0;False;0.0002;0.0007;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;55;1280,640;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1904,624;Float;False;True;-1;3;AmplifyShaderEditor.MaterialInspector;100;5;Blur;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;True;0
WireConnection;60;0;58;2
WireConnection;65;0;60;0
WireConnection;61;0;65;0
WireConnection;59;0;61;0
WireConnection;52;0;59;0
WireConnection;44;0;59;0
WireConnection;45;0;59;0
WireConnection;47;1;52;0
WireConnection;48;0;52;0
WireConnection;48;1;59;0
WireConnection;49;0;59;0
WireConnection;49;1;59;0
WireConnection;50;0;52;0
WireConnection;50;1;52;0
WireConnection;51;0;59;0
WireConnection;51;1;52;0
WireConnection;46;0;52;0
WireConnection;74;0;44;0
WireConnection;75;0;45;0
WireConnection;76;0;46;0
WireConnection;77;0;47;0
WireConnection;78;0;48;0
WireConnection;79;0;49;0
WireConnection;80;0;50;0
WireConnection;81;0;51;0
WireConnection;27;1;81;0
WireConnection;24;1;80;0
WireConnection;21;1;79;0
WireConnection;18;1;78;0
WireConnection;15;1;77;0
WireConnection;12;1;76;0
WireConnection;9;1;75;0
WireConnection;6;1;74;0
WireConnection;8;0;2;0
WireConnection;8;1;6;0
WireConnection;8;7;7;0
WireConnection;11;0;2;0
WireConnection;11;1;9;0
WireConnection;11;7;10;0
WireConnection;14;0;2;0
WireConnection;14;1;12;0
WireConnection;14;7;13;0
WireConnection;17;0;2;0
WireConnection;17;1;15;0
WireConnection;17;7;16;0
WireConnection;20;0;2;0
WireConnection;20;1;18;0
WireConnection;20;7;19;0
WireConnection;23;0;2;0
WireConnection;23;1;21;0
WireConnection;23;7;22;0
WireConnection;26;0;2;0
WireConnection;26;1;24;0
WireConnection;26;7;25;0
WireConnection;3;0;2;0
WireConnection;3;1;4;0
WireConnection;3;7;5;0
WireConnection;29;0;2;0
WireConnection;29;1;27;0
WireConnection;29;7;28;0
WireConnection;53;0;3;5
WireConnection;53;1;8;5
WireConnection;53;2;11;5
WireConnection;53;3;14;5
WireConnection;53;4;17;5
WireConnection;53;5;20;5
WireConnection;53;6;23;5
WireConnection;53;7;26;5
WireConnection;53;8;29;5
WireConnection;41;0;53;0
WireConnection;41;1;54;0
WireConnection;57;1;73;0
WireConnection;66;0;41;0
WireConnection;66;1;62;5
WireConnection;67;0;66;0
WireConnection;72;0;57;1
WireConnection;55;0;67;0
WireConnection;55;3;72;0
WireConnection;0;0;55;0
ASEEND*/
//CHKSM=A56A926A9F58CA17739FC870FF8FC33D1FB58E41