Shader "Unlit/NewUnlitShader"
{
    // Input data 
    Properties
    {
        _Value ("Value", Float) = 1.0
        _ColorA ("Color", Color) = (1,1,1,1)
        _ColorB ("Color", Color) = (1,1,1,1)
        _ColorStart("Start color", Range(0,1)) = 0
        _ColorEnd("Start End", Range(0,1)) = 1
        _UVOffset ("UV Offset", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float _Value;
            float _UVOffset;
            float4 _ColorA;
            float4 _ColorB;
            float _ColorStart;
            float _ColorEnd;
            
            
            struct appdata
            { // PEr vertex mesh data 
                float4 vertex : POSITION;
                float3 normals : NORMAL;
                float4 color : COLOR;
                float4 tangent : TANGENT;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            { 
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normals : TEXCOORD1;
            };

            float inverselerp ( float a, float b, float v) {
                return (v-a)/(b-a);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normals = UnityObjectToWorldNormal(v.normals);
                o.uv = (v.uv + _UVOffset) * _Value;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
            
                float t = inverselerp(_ColorStart, _ColorEnd, i.uv.x);
                float4 col = saturate (lerp(_ColorA, _ColorB, t));
                float someline = 0.1 * cos(50 * i.uv.x - _Time.y) ;
                return someline;
            }
            ENDCG
        }
    }
}
