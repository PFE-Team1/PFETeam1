// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_Plateform_01"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		_Deformation("Deformation", Range( 0 , 1)) = 0.03789261
		_Speed_HB("Speed_HB", Float) = 0.3
		_TextureCanvas("Texture Canvas", 2D) = "white" {}
		_TextureSample3("Texture Sample 2", 2D) = "white" {}
		_MainTex("_MainTex", 2D) = "white" {}
		_TextureSample4("Texture Sample 4", 2D) = "white" {}
		_TextureSample5("Texture Sample 5", 2D) = "white" {}
		_TextureSample6("Texture Sample 6", 2D) = "white" {}
		_G_Line_Mask("G_Line_Mask", Range( 0 , 1)) = 0.09454166
		_D_Line_Mask("D_Line_Mask", Range( 0 , 1)) = 0
		_B_Line_Mask("B_Line_Mask", Range( -1 , 1)) = -0.3043478
		_H_Line_Mask("H_Line_Mask", Range( -1 , 1)) = -0.4619671
		_G_Degrade("G_Degrade", Range( 0 , 1)) = 0.4641299
		_D_Degrade("D_Degrade", Range( 0 , 1)) = 0.4406829
		_B_Degrade("B_Degrade", Range( 0 , 1)) = 0.27
		_H_Degrade("H_Degrade", Range( 0 , 1)) = 0.413913
		_Speed_XY("Speed_XY", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

		[HideInInspector][NoScaleOffset] unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
	}

	SubShader
	{
		LOD 0

		

		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Transparent" "Queue"="Transparent" }

		Cull Off

		HLSLINCLUDE
		#pragma target 2.0
		#pragma prefer_hlslcc gles
		// ensure rendering platforms toggle list is visible

		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Filtering.hlsl"

		ENDHLSL

		
		Pass
		{
			Name "Sprite Unlit"
            Tags { "LightMode"="Universal2D" }

			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZTest LEqual
			ZWrite Off
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM

			#define ASE_VERSION 19801
			#define ASE_SRP_VERSION 140008


			#pragma vertex vert
			#pragma fragment frag

            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_COLOR
            #define FEATURES_GRAPH_VERTEX

			#define SHADERPASS SHADERPASS_SPRITEUNLIT

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"

			

			

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/SurfaceData2D.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Debug/Debugging2D.hlsl"

			

			sampler2D _MainTex;
			sampler2D _TextureCanvas;
			sampler2D _TextureSample3;
			sampler2D _TextureSample4;
			sampler2D _TextureSample5;
			sampler2D _TextureSample6;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float4 _TextureSample3_ST;
			float4 _TextureSample4_ST;
			float4 _TextureSample5_ST;
			float4 _TextureSample6_ST;
			float _Speed_XY;
			float _Speed_HB;
			float _Deformation;
			float _G_Line_Mask;
			float _G_Degrade;
			float _D_Line_Mask;
			float _D_Degrade;
			float _B_Line_Mask;
			float _B_Degrade;
			float _H_Line_Mask;
			float _H_Degrade;
			CBUFFER_END


			struct VertexInput
			{
				float4 positionOS : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 color : COLOR;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 texCoord0 : TEXCOORD0;
				float4 color : TEXCOORD1;
				float3 positionWS : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			#if ETC1_EXTERNAL_ALPHA
				TEXTURE2D(_AlphaTex); SAMPLER(sampler_AlphaTex);
				float _EnableAlphaTexture;
			#endif

			float4 _RendererColor;

			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			

			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif
				v.normal = v.normal;
				v.tangent.xyz = v.tangent.xyz;

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.positionOS.xyz);

				o.positionCS = vertexInput.positionCS;
				o.positionWS = vertexInput.positionWS;
				o.texCoord0 = v.uv0;
				o.color = v.color;
				return o;
			}

			half4 frag( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				float2 uv_MainTex = IN.texCoord0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 appendResult44 = (float4(_Speed_XY , _Speed_HB , 0.0 , 0.0));
				float2 texCoord41 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner45 = ( 1.0 * _Time.y * appendResult44.xy + (texCoord41*1.0 + 0.0));
				float simplePerlin2D46 = snoise( panner45*2.39 );
				simplePerlin2D46 = simplePerlin2D46*0.5 + 0.5;
				float2 texCoord49 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DNode51 = tex2D( _TextureCanvas, ( ( simplePerlin2D46 * _Deformation ) + texCoord49 ) );
				float4 appendResult52 = (float4(tex2DNode51.rgb , tex2DNode51.r));
				float2 texCoord63 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult79 = smoothstep( _G_Line_Mask , _G_Degrade , ( ( texCoord63.x - -0.12 ) * step( ( texCoord63.x - 1.24 ) , 0.15 ) ));
				float2 uv_TextureSample3 = IN.texCoord0.xy * _TextureSample3_ST.xy + _TextureSample3_ST.zw;
				float2 uv_TextureSample4 = IN.texCoord0.xy * _TextureSample4_ST.xy + _TextureSample4_ST.zw;
				float2 texCoord62 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult78 = smoothstep( _D_Line_Mask , _D_Degrade , ( ( 1.0 - texCoord62.x ) * step( ( -0.29 - texCoord62.x ) , 0.15 ) ));
				float2 uv_TextureSample5 = IN.texCoord0.xy * _TextureSample5_ST.xy + _TextureSample5_ST.zw;
				float2 texCoord83 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult97 = smoothstep( _B_Line_Mask , _B_Degrade , ( ( texCoord83.y - 0.32 ) * step( ( texCoord83.y - 1.18 ) , 0.15 ) ));
				float2 uv_TextureSample6 = IN.texCoord0.xy * _TextureSample6_ST.xy + _TextureSample6_ST.zw;
				float2 texCoord84 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult98 = smoothstep( _H_Line_Mask , _H_Degrade , ( ( 0.71 - texCoord84.y ) * step( ( -0.29 - texCoord84.y ) , 0.15 ) ));
				
				float4 Color = ( tex2D( _MainTex, uv_MainTex ).r * appendResult52 * ( ( smoothstepResult79 * tex2D( _TextureSample3, uv_TextureSample3 ).r ) * ( tex2D( _TextureSample4, uv_TextureSample4 ).r * smoothstepResult78 ) * ( tex2D( _TextureSample5, uv_TextureSample5 ).r * smoothstepResult97 ) * ( tex2D( _TextureSample6, uv_TextureSample6 ).r * smoothstepResult98 ) ) );

				#if ETC1_EXTERNAL_ALPHA
					float4 alpha = SAMPLE_TEXTURE2D(_AlphaTex, sampler_AlphaTex, IN.texCoord0.xy);
					Color.a = lerp( Color.a, alpha.r, _EnableAlphaTexture);
				#endif

				#if defined(DEBUG_DISPLAY)
				SurfaceData2D surfaceData;
				InitializeSurfaceData(Color.rgb, Color.a, surfaceData);
				InputData2D inputData;
				InitializeInputData(IN.positionWS.xy, half2(IN.texCoord0.xy), inputData);
				half4 debugColor = 0;

				SETUP_DEBUG_DATA_2D(inputData, IN.positionWS);

				if (CanDebugOverrideOutputColor(surfaceData, inputData, debugColor))
				{
					return debugColor;
				}
				#endif

				Color *= IN.color * _RendererColor;
				return Color;
			}

			ENDHLSL
		}

		
		Pass
		{
			
            Name "Sprite Unlit Forward"
            Tags { "LightMode"="UniversalForward" }

			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZTest LEqual
			ZWrite Off
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM

			#define ASE_VERSION 19801
			#define ASE_SRP_VERSION 140008


			#pragma vertex vert
			#pragma fragment frag

            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_COLOR
            #define FEATURES_GRAPH_VERTEX

			#define SHADERPASS SHADERPASS_SPRITEFORWARD

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"

			

			

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/SurfaceData2D.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Debug/Debugging2D.hlsl"

			

			sampler2D _MainTex;
			sampler2D _TextureCanvas;
			sampler2D _TextureSample3;
			sampler2D _TextureSample4;
			sampler2D _TextureSample5;
			sampler2D _TextureSample6;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float4 _TextureSample3_ST;
			float4 _TextureSample4_ST;
			float4 _TextureSample5_ST;
			float4 _TextureSample6_ST;
			float _Speed_XY;
			float _Speed_HB;
			float _Deformation;
			float _G_Line_Mask;
			float _G_Degrade;
			float _D_Line_Mask;
			float _D_Degrade;
			float _B_Line_Mask;
			float _B_Degrade;
			float _H_Line_Mask;
			float _H_Degrade;
			CBUFFER_END


			struct VertexInput
			{
				float4 positionOS : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 color : COLOR;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 texCoord0 : TEXCOORD0;
				float4 color : TEXCOORD1;
				float3 positionWS : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			#if ETC1_EXTERNAL_ALPHA
				TEXTURE2D( _AlphaTex ); SAMPLER( sampler_AlphaTex );
				float _EnableAlphaTexture;
			#endif

			float4 _RendererColor;

			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			

			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif
				v.normal = v.normal;
				v.tangent.xyz = v.tangent.xyz;

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.positionOS.xyz);

				o.positionCS = vertexInput.positionCS;
				o.positionWS = vertexInput.positionWS;
				o.texCoord0 = v.uv0;
				o.color = v.color;

				return o;
			}

			half4 frag( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				float2 uv_MainTex = IN.texCoord0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 appendResult44 = (float4(_Speed_XY , _Speed_HB , 0.0 , 0.0));
				float2 texCoord41 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner45 = ( 1.0 * _Time.y * appendResult44.xy + (texCoord41*1.0 + 0.0));
				float simplePerlin2D46 = snoise( panner45*2.39 );
				simplePerlin2D46 = simplePerlin2D46*0.5 + 0.5;
				float2 texCoord49 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DNode51 = tex2D( _TextureCanvas, ( ( simplePerlin2D46 * _Deformation ) + texCoord49 ) );
				float4 appendResult52 = (float4(tex2DNode51.rgb , tex2DNode51.r));
				float2 texCoord63 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult79 = smoothstep( _G_Line_Mask , _G_Degrade , ( ( texCoord63.x - -0.12 ) * step( ( texCoord63.x - 1.24 ) , 0.15 ) ));
				float2 uv_TextureSample3 = IN.texCoord0.xy * _TextureSample3_ST.xy + _TextureSample3_ST.zw;
				float2 uv_TextureSample4 = IN.texCoord0.xy * _TextureSample4_ST.xy + _TextureSample4_ST.zw;
				float2 texCoord62 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult78 = smoothstep( _D_Line_Mask , _D_Degrade , ( ( 1.0 - texCoord62.x ) * step( ( -0.29 - texCoord62.x ) , 0.15 ) ));
				float2 uv_TextureSample5 = IN.texCoord0.xy * _TextureSample5_ST.xy + _TextureSample5_ST.zw;
				float2 texCoord83 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult97 = smoothstep( _B_Line_Mask , _B_Degrade , ( ( texCoord83.y - 0.32 ) * step( ( texCoord83.y - 1.18 ) , 0.15 ) ));
				float2 uv_TextureSample6 = IN.texCoord0.xy * _TextureSample6_ST.xy + _TextureSample6_ST.zw;
				float2 texCoord84 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult98 = smoothstep( _H_Line_Mask , _H_Degrade , ( ( 0.71 - texCoord84.y ) * step( ( -0.29 - texCoord84.y ) , 0.15 ) ));
				
				float4 Color = ( tex2D( _MainTex, uv_MainTex ).r * appendResult52 * ( ( smoothstepResult79 * tex2D( _TextureSample3, uv_TextureSample3 ).r ) * ( tex2D( _TextureSample4, uv_TextureSample4 ).r * smoothstepResult78 ) * ( tex2D( _TextureSample5, uv_TextureSample5 ).r * smoothstepResult97 ) * ( tex2D( _TextureSample6, uv_TextureSample6 ).r * smoothstepResult98 ) ) );

				#if ETC1_EXTERNAL_ALPHA
					float4 alpha = SAMPLE_TEXTURE2D( _AlphaTex, sampler_AlphaTex, IN.texCoord0.xy );
					Color.a = lerp( Color.a, alpha.r, _EnableAlphaTexture );
				#endif


				#if defined(DEBUG_DISPLAY)
					SurfaceData2D surfaceData;
					InitializeSurfaceData(Color.rgb, Color.a, surfaceData);
					InputData2D inputData;
					InitializeInputData(IN.positionWS.xy, half2(IN.texCoord0.xy), inputData);
					half4 debugColor = 0;

					SETUP_DEBUG_DATA_2D(inputData, IN.positionWS);

					if (CanDebugOverrideOutputColor(surfaceData, inputData, debugColor))
					{
						return debugColor;
					}
				#endif

				Color *= IN.color * _RendererColor;
				return Color;
			}

			ENDHLSL
		}
		
        Pass
        {
			
            Name "SceneSelectionPass"
            Tags { "LightMode"="SceneSelectionPass" }

            Cull Off

            HLSLPROGRAM

			#define ASE_VERSION 19801
			#define ASE_SRP_VERSION 140008


			#pragma vertex vert
			#pragma fragment frag

            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define FEATURES_GRAPH_VERTEX

            #define SHADERPASS SHADERPASS_DEPTHONLY
			#define SCENESELECTIONPASS 1

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"

			

			

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			

			sampler2D _MainTex;
			sampler2D _TextureCanvas;
			sampler2D _TextureSample3;
			sampler2D _TextureSample4;
			sampler2D _TextureSample5;
			sampler2D _TextureSample6;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float4 _TextureSample3_ST;
			float4 _TextureSample4_ST;
			float4 _TextureSample5_ST;
			float4 _TextureSample6_ST;
			float _Speed_XY;
			float _Speed_HB;
			float _Deformation;
			float _G_Line_Mask;
			float _G_Degrade;
			float _D_Line_Mask;
			float _D_Degrade;
			float _B_Line_Mask;
			float _B_Degrade;
			float _H_Line_Mask;
			float _H_Degrade;
			CBUFFER_END


            struct VertexInput
			{
				float3 positionOS : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

            int _ObjectId;
            int _PassValue;

			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			

			VertexOutput vert(VertexInput v )
			{
				VertexOutput o = (VertexOutput)0;

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.positionOS.xyz);
				float3 positionWS = TransformObjectToWorld(v.positionOS);
				o.positionCS = TransformWorldToHClip(positionWS);

				return o;
			}

			half4 frag(VertexOutput IN) : SV_TARGET
			{
				float2 uv_MainTex = IN.ase_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 appendResult44 = (float4(_Speed_XY , _Speed_HB , 0.0 , 0.0));
				float2 texCoord41 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner45 = ( 1.0 * _Time.y * appendResult44.xy + (texCoord41*1.0 + 0.0));
				float simplePerlin2D46 = snoise( panner45*2.39 );
				simplePerlin2D46 = simplePerlin2D46*0.5 + 0.5;
				float2 texCoord49 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DNode51 = tex2D( _TextureCanvas, ( ( simplePerlin2D46 * _Deformation ) + texCoord49 ) );
				float4 appendResult52 = (float4(tex2DNode51.rgb , tex2DNode51.r));
				float2 texCoord63 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult79 = smoothstep( _G_Line_Mask , _G_Degrade , ( ( texCoord63.x - -0.12 ) * step( ( texCoord63.x - 1.24 ) , 0.15 ) ));
				float2 uv_TextureSample3 = IN.ase_texcoord.xy * _TextureSample3_ST.xy + _TextureSample3_ST.zw;
				float2 uv_TextureSample4 = IN.ase_texcoord.xy * _TextureSample4_ST.xy + _TextureSample4_ST.zw;
				float2 texCoord62 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult78 = smoothstep( _D_Line_Mask , _D_Degrade , ( ( 1.0 - texCoord62.x ) * step( ( -0.29 - texCoord62.x ) , 0.15 ) ));
				float2 uv_TextureSample5 = IN.ase_texcoord.xy * _TextureSample5_ST.xy + _TextureSample5_ST.zw;
				float2 texCoord83 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult97 = smoothstep( _B_Line_Mask , _B_Degrade , ( ( texCoord83.y - 0.32 ) * step( ( texCoord83.y - 1.18 ) , 0.15 ) ));
				float2 uv_TextureSample6 = IN.ase_texcoord.xy * _TextureSample6_ST.xy + _TextureSample6_ST.zw;
				float2 texCoord84 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult98 = smoothstep( _H_Line_Mask , _H_Degrade , ( ( 0.71 - texCoord84.y ) * step( ( -0.29 - texCoord84.y ) , 0.15 ) ));
				
				float4 Color = ( tex2D( _MainTex, uv_MainTex ).r * appendResult52 * ( ( smoothstepResult79 * tex2D( _TextureSample3, uv_TextureSample3 ).r ) * ( tex2D( _TextureSample4, uv_TextureSample4 ).r * smoothstepResult78 ) * ( tex2D( _TextureSample5, uv_TextureSample5 ).r * smoothstepResult97 ) * ( tex2D( _TextureSample6, uv_TextureSample6 ).r * smoothstepResult98 ) ) );

				half4 outColor = half4(_ObjectId, _PassValue, 1.0, 1.0);
				return outColor;
			}

            ENDHLSL
        }

		
        Pass
        {
			
            Name "ScenePickingPass"
            Tags { "LightMode"="Picking" }

			Cull Off

            HLSLPROGRAM

			#define ASE_VERSION 19801
			#define ASE_SRP_VERSION 140008


			#pragma vertex vert
			#pragma fragment frag

            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define FEATURES_GRAPH_VERTEX

            #define SHADERPASS SHADERPASS_DEPTHONLY
			#define SCENEPICKINGPASS 1

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"

			

			

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

        	

			sampler2D _MainTex;
			sampler2D _TextureCanvas;
			sampler2D _TextureSample3;
			sampler2D _TextureSample4;
			sampler2D _TextureSample5;
			sampler2D _TextureSample6;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float4 _TextureSample3_ST;
			float4 _TextureSample4_ST;
			float4 _TextureSample5_ST;
			float4 _TextureSample6_ST;
			float _Speed_XY;
			float _Speed_HB;
			float _Deformation;
			float _G_Line_Mask;
			float _G_Degrade;
			float _D_Line_Mask;
			float _D_Degrade;
			float _B_Line_Mask;
			float _B_Degrade;
			float _H_Line_Mask;
			float _H_Degrade;
			CBUFFER_END


            struct VertexInput
			{
				float3 positionOS : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

            float4 _SelectionID;

			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			

			VertexOutput vert(VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.positionOS.xyz);
				float3 positionWS = TransformObjectToWorld(v.positionOS);
				o.positionCS = TransformWorldToHClip(positionWS);

				return o;
			}

			half4 frag(VertexOutput IN ) : SV_TARGET
			{
				float2 uv_MainTex = IN.ase_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 appendResult44 = (float4(_Speed_XY , _Speed_HB , 0.0 , 0.0));
				float2 texCoord41 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner45 = ( 1.0 * _Time.y * appendResult44.xy + (texCoord41*1.0 + 0.0));
				float simplePerlin2D46 = snoise( panner45*2.39 );
				simplePerlin2D46 = simplePerlin2D46*0.5 + 0.5;
				float2 texCoord49 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DNode51 = tex2D( _TextureCanvas, ( ( simplePerlin2D46 * _Deformation ) + texCoord49 ) );
				float4 appendResult52 = (float4(tex2DNode51.rgb , tex2DNode51.r));
				float2 texCoord63 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult79 = smoothstep( _G_Line_Mask , _G_Degrade , ( ( texCoord63.x - -0.12 ) * step( ( texCoord63.x - 1.24 ) , 0.15 ) ));
				float2 uv_TextureSample3 = IN.ase_texcoord.xy * _TextureSample3_ST.xy + _TextureSample3_ST.zw;
				float2 uv_TextureSample4 = IN.ase_texcoord.xy * _TextureSample4_ST.xy + _TextureSample4_ST.zw;
				float2 texCoord62 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult78 = smoothstep( _D_Line_Mask , _D_Degrade , ( ( 1.0 - texCoord62.x ) * step( ( -0.29 - texCoord62.x ) , 0.15 ) ));
				float2 uv_TextureSample5 = IN.ase_texcoord.xy * _TextureSample5_ST.xy + _TextureSample5_ST.zw;
				float2 texCoord83 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult97 = smoothstep( _B_Line_Mask , _B_Degrade , ( ( texCoord83.y - 0.32 ) * step( ( texCoord83.y - 1.18 ) , 0.15 ) ));
				float2 uv_TextureSample6 = IN.ase_texcoord.xy * _TextureSample6_ST.xy + _TextureSample6_ST.zw;
				float2 texCoord84 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult98 = smoothstep( _H_Line_Mask , _H_Degrade , ( ( 0.71 - texCoord84.y ) * step( ( -0.29 - texCoord84.y ) , 0.15 ) ));
				
				float4 Color = ( tex2D( _MainTex, uv_MainTex ).r * appendResult52 * ( ( smoothstepResult79 * tex2D( _TextureSample3, uv_TextureSample3 ).r ) * ( tex2D( _TextureSample4, uv_TextureSample4 ).r * smoothstepResult78 ) * ( tex2D( _TextureSample5, uv_TextureSample5 ).r * smoothstepResult97 ) * ( tex2D( _TextureSample6, uv_TextureSample6 ).r * smoothstepResult98 ) ) );
				half4 outColor = _SelectionID;
				return outColor;
			}

            ENDHLSL
        }
		
	}
	CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
	FallBack "Hidden/Shader Graph/FallbackError"
	
	Fallback Off
}
/*ASEBEGIN
Version=19801
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;-2144,-992;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;42;-1984,-656;Inherit;False;Property;_Speed_HB;Speed_HB;1;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;103;-2000,-736;Inherit;False;Property;_Speed_XY;Speed_XY;16;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;43;-1792,-912;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;44;-1744,-736;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;63;-2416,32;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;62;-2288,960;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;83;-2432,1696;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;84;-2288,2400;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;45;-1504,-912;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.06,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;64;-1952,1024;Inherit;True;2;0;FLOAT;-0.29;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;65;-2064,64;Inherit;True;2;0;FLOAT;0.58;False;1;FLOAT;1.24;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;85;-2080,1728;Inherit;True;2;0;FLOAT;-0.29;False;1;FLOAT;1.18;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;86;-1936,2432;Inherit;True;2;0;FLOAT;-0.29;False;1;FLOAT;1.18;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;46;-1232,-912;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;2.39;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;68;-1824,0;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;69;-2064,-160;Inherit;True;2;0;FLOAT;0.58;False;1;FLOAT;-0.12;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;66;-1696,928;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;67;-1936,768;Inherit;True;2;0;FLOAT;1;False;1;FLOAT;0.07;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;87;-1840,1664;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;89;-1696,2368;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;90;-1936,2208;Inherit;True;2;0;FLOAT;0.71;False;1;FLOAT;0.02;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;88;-2080,1504;Inherit;True;2;0;FLOAT;1.09;False;1;FLOAT;0.32;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-1232,-624;Inherit;False;Property;_Deformation;Deformation;0;0;Create;True;0;0;0;False;0;False;0.03789261;0.03789261;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-832,-848;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;49;-1024,-496;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;71;-1600,192;Inherit;False;Property;_G_Degrade;G_Degrade;12;0;Create;True;0;0;0;False;0;False;0.4641299;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-1600,96;Inherit;False;Property;_G_Line_Mask;G_Line_Mask;8;0;Create;True;0;0;0;False;0;False;0.09454166;0.12;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-1584,-144;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-1504,1056;Inherit;False;Property;_D_Line_Mask;D_Line_Mask;9;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-1472,1184;Inherit;False;Property;_D_Degrade;D_Degrade;13;0;Create;True;0;0;0;False;0;False;0.4406829;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-1456,784;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-1456,2224;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-1600,1520;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-1568,1872;Inherit;False;Property;_B_Degrade;B_Degrade;14;0;Create;True;0;0;0;False;0;False;0.27;0.27;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-1408,2608;Inherit;False;Property;_H_Degrade;H_Degrade;15;0;Create;True;0;0;0;False;0;False;0.413913;0.24;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-1456,2496;Inherit;False;Property;_H_Line_Mask;H_Line_Mask;11;0;Create;True;0;0;0;False;0;False;-0.4619671;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-1616,1776;Inherit;False;Property;_B_Line_Mask;B_Line_Mask;10;0;Create;True;0;0;0;False;0;False;-0.3043478;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-640,-784;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;57;-688,-544;Inherit;True;Property;_TextureCanvas;Texture Canvas;2;0;Create;True;0;0;0;False;0;False;436d9a27751e5de45851ee41dafe8bf5;436d9a27751e5de45851ee41dafe8bf5;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;76;-1184,288;Inherit;True;Property;_TextureSample3;Texture Sample 2;3;0;Create;True;0;0;0;False;0;False;-1;436d9a27751e5de45851ee41dafe8bf5;436d9a27751e5de45851ee41dafe8bf5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SmoothstepOpNode;79;-1216,-48;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.12;False;2;FLOAT;0.34;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;77;-1184,544;Inherit;True;Property;_TextureSample4;Texture Sample 4;5;0;Create;True;0;0;0;False;0;False;-1;436d9a27751e5de45851ee41dafe8bf5;436d9a27751e5de45851ee41dafe8bf5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SmoothstepOpNode;78;-1152,784;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;97;-1280,1536;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.27;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;98;-1168,2224;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.24;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;99;-1216,1312;Inherit;True;Property;_TextureSample5;Texture Sample 5;6;0;Create;True;0;0;0;False;0;False;-1;436d9a27751e5de45851ee41dafe8bf5;436d9a27751e5de45851ee41dafe8bf5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;100;-1296,2016;Inherit;True;Property;_TextureSample6;Texture Sample 6;7;0;Create;True;0;0;0;False;0;False;-1;436d9a27751e5de45851ee41dafe8bf5;436d9a27751e5de45851ee41dafe8bf5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;51;-448,-832;Inherit;True;Property;_TextureSample2;Texture Sample 1;3;0;Create;True;0;0;0;False;0;False;57;61ac4bb5c5276264580c988b076dcd09;61ac4bb5c5276264580c988b076dcd09;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-864,0;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-832,768;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-832,1392;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-832,2208;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;54;-176,-1200;Inherit;True;Property;_MainTex;_MainTex;4;0;Create;False;0;0;0;False;0;False;57;436d9a27751e5de45851ee41dafe8bf5;436d9a27751e5de45851ee41dafe8bf5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.DynamicAppendNode;52;-48,-784;Inherit;True;COLOR;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;96,0;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;560,-768;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;61;432,-1152;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-3.9;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;0,0;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;1;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;Sprite Unlit Forward;0;1;Sprite Unlit Forward;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalForward;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;0,0;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;1;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;SceneSelectionPass;0;2;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;1;New Amplify Shader;cf964e524c8e69742b1d21fbe2ebcc4a;True;ScenePickingPass;0;3;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;976,-704;Float;False;True;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;15;SH_Plateform_01;cf964e524c8e69742b1d21fbe2ebcc4a;True;Sprite Unlit;0;0;Sprite Unlit;4;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=Universal2D;False;False;0;;0;0;Standard;3;Vertex Position;1;0;Debug Display;0;0;External Alpha;0;0;0;4;True;True;True;True;False;;False;0
WireConnection;43;0;41;0
WireConnection;44;0;103;0
WireConnection;44;1;42;0
WireConnection;45;0;43;0
WireConnection;45;2;44;0
WireConnection;64;1;62;1
WireConnection;65;0;63;1
WireConnection;85;0;83;2
WireConnection;86;1;84;2
WireConnection;46;0;45;0
WireConnection;68;0;65;0
WireConnection;69;0;63;1
WireConnection;66;0;64;0
WireConnection;67;1;62;1
WireConnection;87;0;85;0
WireConnection;89;0;86;0
WireConnection;90;1;84;2
WireConnection;88;0;83;2
WireConnection;48;0;46;0
WireConnection;48;1;47;0
WireConnection;75;0;69;0
WireConnection;75;1;68;0
WireConnection;74;0;67;0
WireConnection;74;1;66;0
WireConnection;91;0;90;0
WireConnection;91;1;89;0
WireConnection;92;0;88;0
WireConnection;92;1;87;0
WireConnection;50;0;48;0
WireConnection;50;1;49;0
WireConnection;79;0;75;0
WireConnection;79;1;72;0
WireConnection;79;2;71;0
WireConnection;78;0;74;0
WireConnection;78;1;70;0
WireConnection;78;2;73;0
WireConnection;97;0;92;0
WireConnection;97;1;93;0
WireConnection;97;2;95;0
WireConnection;98;0;91;0
WireConnection;98;1;94;0
WireConnection;98;2;96;0
WireConnection;51;0;57;0
WireConnection;51;1;50;0
WireConnection;80;0;79;0
WireConnection;80;1;76;1
WireConnection;81;0;77;1
WireConnection;81;1;78;0
WireConnection;101;0;99;1
WireConnection;101;1;97;0
WireConnection;102;0;100;1
WireConnection;102;1;98;0
WireConnection;52;0;51;5
WireConnection;52;3;51;1
WireConnection;82;0;80;0
WireConnection;82;1;81;0
WireConnection;82;2;101;0
WireConnection;82;3;102;0
WireConnection;53;0;54;1
WireConnection;53;1;52;0
WireConnection;53;2;82;0
WireConnection;0;1;53;0
ASEEND*/
//CHKSM=BFD1DFED22C08B35D40DB88D89C02FD342FF67F9