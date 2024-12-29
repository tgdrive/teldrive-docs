<script setup lang="ts">
import { ApiReference } from '@scalar/api-reference'
import '@scalar/api-reference/style.css'
import spec from "../openapi/openapi.json"
</script>

<template>
  <div>
    <ApiReference
      :configuration="{
        spec: {
         content: spec,
        },
      }" />
  </div>
</template>