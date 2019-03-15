Shader "Ball/UVScroll"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MainColor("Color", Color) = (0,0,1,1)
		_ScrollSpeed("ScrollSpeed", Vector) = (0,0,0,0)
		
		_UScaler("U Scale", Range(0, 1)) = 0.1
		_VScaler("V Scale", Range(0, 1)) = 0.2
		
		_UDepth("Depth U", Range(0, 30)) = 18
		_VDepth("Depth V", Range(0, 30)) = 15
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _MainColor;
			float2 _ScrollSpeed;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			float _UDepth;
            float _VDepth;
            float _UScaler;
            float _VScaler;
			fixed4 frag (v2f i) : SV_Target
			{
                float u = i.uv.x + sin(_Time );
                float v = i.uv.y + sin(_Time );
                float newU = sin((_UDepth * u + (_Time.y * _ScrollSpeed.x)) * 0.25) * _UScaler + v;
			    float newV = sin((_VDepth * v + (_Time.y  * _ScrollSpeed.y)) * 0.25) * _VScaler + u;
			    
			    float2 uv = i.uv + float2(_Time.y * _ScrollSpeed);
			    float2 uv2 = float2(newU, newV);
                fixed4 tex3 = tex2D(_MainTex, uv2);
                return tex3;
			}
			ENDCG
		}
	}
}
