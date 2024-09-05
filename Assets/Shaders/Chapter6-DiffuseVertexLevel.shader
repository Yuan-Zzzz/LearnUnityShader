// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 6/Diffuse Vertex-Level"
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
                float4 color : COLOR;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                //MVP矩阵变换，将顶点坐标从模型空间转换到裁剪空间
                o.pos =mul(unity_MatrixMVP, v.vertex);

                //--------------------光照模型的漫反射颜色------------------------------
                //环境光照颜色
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                //将法线向量从模型空间转换到世界空间
                fixed3 normal = normalize(mul((float3x3)unity_ObjectToWorld, v.normal));
                //获取光照方向
                fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                //计算漫反射光照颜色
                fixed3 diffuse = max(0, dot(normal, lightDir)) * _LightColor0.rgb * _Diffuse.rgb;
                //将漫反射光照颜色与环境光照颜色相加
                o.color = fixed4(ambient + diffuse, 1);
                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                return i.color;
            }
            
            ENDCG
        }
    }
}