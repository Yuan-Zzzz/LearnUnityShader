// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 6/Diffuse Pixel-Level"
{
    Properties
    {
        _Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Pass
        {
            Tags{"LightMode" = "ForwardBase"}
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"
            //定义与Properties中的_Diffuse属性对应的变量
            fixed4 _Diffuse;

            struct a2v
            {
                float4 pos : SV_POSITION;
                float4 color : COLOR;
            };
            
            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 normal : TEXCOORD0;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                //MVP矩阵变换，将顶点坐标从模型空间转换到裁剪空间
                o.pos =mul(unity_MatrixMVP, v.vertex);
                //将法线向量从模型空间转换到剪裁空间
                o.normal = mul((float3x3)unity_WorldToObject, v.normal);
                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                  //--------------------光照模型的漫反射颜色------------------------------
                //环境光照颜色
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                //获取光照方向
                fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                //获取法线向量
                fixed3 normal = normalize(i.normal);
                //计算漫反射光照颜色
                fixed3 diffuse = max(0, dot(normal, lightDir)) * _LightColor0.rgb * _Diffuse.rgb;
                //将漫反射光照颜色与环境光照颜色相加
                fixed4 color = fixed4(ambient + diffuse, 1);
                return color;
            }
            
            ENDCG
        }
    }
}