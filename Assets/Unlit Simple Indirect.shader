Shader "Custom/Unlit Simple Indirect" {
    Properties {
        _BaseColor("Color", Color) = (1, 1, 1, 1)
        _Size("Size", Float) = 1
    }

    SubShader {
        Tags { "RenderType" = "Opaque" "IgnoreProjector" = "True" "RenderPipeline" = "LightweightPipeline" }
        LOD 100

        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite On
        ZTest LEqual
        Cull Back

        Pass {
            Name "Unlit Simple Indirect"

            HLSLPROGRAM
                #pragma require compute
                #pragma prefer_hlslcc gles

                #pragma vertex vert
                #pragma fragment frag

                #pragma multi_compile_instancing

                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

                struct Attributes {
                    float4 vertex : POSITION;
                    UNITY_VERTEX_INPUT_INSTANCE_ID
                };

                struct Varyings {
                    float4 vertex : SV_POSITION;
                    UNITY_VERTEX_INPUT_INSTANCE_ID
                };

                StructuredBuffer<float4> positionBuffer;

                half4 _BaseColor;
                float _Size;

                Varyings vert(Attributes input, uint instanceID : SV_InstanceID) {
                    Varyings output = (Varyings)0;

                    UNITY_SETUP_INSTANCE_ID(input);
                    UNITY_TRANSFER_INSTANCE_ID(input, output);

                    float4 data = positionBuffer[instanceID];

                    float3 localPosition = input.vertex.xyz;
                    float3 localPositionScaled = localPosition * _Size;
                    float3 instanceOffset = data.xyz;
                    float3 worldPosition = instanceOffset + localPositionScaled;

                    output.vertex = mul(UNITY_MATRIX_VP, mul(unity_ObjectToWorld, float4(worldPosition, 1)));

                    return output;
                }

                half4 frag(Varyings input) : SV_Target {
                    return _BaseColor;
                }
            ENDHLSL
        }
    }

    FallBack "Hidden/InternalErrorShader"
}
