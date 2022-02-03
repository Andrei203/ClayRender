Shader "Unlit/HLSLShader"
{
    //variable properties that can be customised further in unity editor.
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BaseColor("Basee Color", Color) = (1,1,1,1)
    }
        SubShader
        {
            Pass 
            { 
                Tags { "RenderType" = "Opaque" }
                LOD 100

                HLSLPROGRAM
                #pragma target 3.0
                #include "UnityCG.cginc"
                #include "Lighting.cginc"
                static float pi = 3.1416f;
                struct VertexInput
                {
                    float4 position : POSITION;
                    float2 uv : TEXCOORD0;
                    float3 normal : NORMAL;
                };

                struct VertexOutput
                {
                    float4 position : SV_POSITION;
                    float2 uv : TEXCOORD0;
                    float3 normal : NORMAL;
                    float3 world_position : TEXCOORD2;
                };

                float3 lambert_diffuse(const float3 albedo, const float3 light_color, const float intesity)
                {
                    return albedo / pi * intesity * light_color;
                }
                
                #pragma vertex vert
                #pragma fragment frag
                   VertexOutput vert(appdata_full i)
                   {
                        VertexOutput o;
                        o.position = UnityObjectToClipPos(i.vertex);
                        o.normal   = UnityObjectToWorldNormal(i.normal);
                        o.uv = float4(i.texcoord.xy, 0.0f, 0.0f);
                        o.world_position = mul(unity_ObjectToWorld, i.vertex).xyz;
                        return o;
                   }
                   sampler2D _MainTex;
                
                float4 _BaseColor;

                float4 frag(VertexOutput i) : SV_Target
                {
                    float4 baseTex = tex2D(_MainTex, i.uv);
                    //return baseTex * _BaseColor;
                    //light info
                    UnityLight lighting;
                    lighting.dir = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.world_position.xyz, _WorldSpaceLightPos0.w));
                    lighting.color = _LightColor0;

                    //Dot products
                    const half n_dot_l = max(dot(i.normal, lighting.dir), 0.0f);
                    return n_dot_l * baseTex * _BaseColor;
                }

                ENDHLSL
       
            }
        }
           
}
