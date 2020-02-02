Shader "Custom/Unlit Simple" {
    Properties {
        _BaseColor("Color", Color) = (1, 1, 1, 1)
    }

    SubShader {
        Tags { "RenderType" = "Opaque" "IgnoreProjector" = "True" "RenderPipeline" = "LightweightPipeline" }
        LOD 100

        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite On
		ZTest LEqual
        Cull Back

        Pass {
            Name "Unlit Simple"

            HLSLPROGRAM
				#pragma prefer_hlslcc gles

				#pragma vertex vert
				#pragma fragment frag

				#pragma multi_compile_instancing

				#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"

				struct Attributes {
					float4 vertex : POSITION;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct Varyings {
					float4 vertex : SV_POSITION;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				half4 _BaseColor;

				Varyings vert(Attributes input) {
					Varyings output = (Varyings)0;

					UNITY_SETUP_INSTANCE_ID(input);
					UNITY_TRANSFER_INSTANCE_ID(input, output);

					float3 worldPosition = input.vertex.xyz;

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
