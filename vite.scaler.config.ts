import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import path from 'path';
import fs from 'fs';
import { promisify } from 'util';
import { pipeline } from 'stream';

const pipelineAsync = promisify(pipeline);

async function copyFile(src:string, dest:string) {
  await fs.promises.mkdir(path.dirname(dest), { recursive: true });
  await pipelineAsync(
    fs.createReadStream(src),
    fs.createWriteStream(dest)
  );
}

async function copyDirectory(src:string, dest:string) {
  const entries = await fs.promises.readdir(src, { withFileTypes: true });

  await fs.promises.mkdir(dest, { recursive: true });

  for (let entry of entries) {
    const srcPath = path.join(src, entry.name);
    const destPath = path.join(dest, entry.name);

    if (entry.isDirectory()) {
      await copyDirectory(srcPath, destPath);
    } else {
      await pipelineAsync(
        fs.createReadStream(srcPath),
        fs.createWriteStream(destPath)
      );
    }
  }
}

export default defineConfig({
  plugins: [vue(), {
    name: 'postbuild',
    closeBundle: async () => {
      const srcDir = path.resolve(__dirname, 'dist/assets');
      const destDir = path.resolve(__dirname, '.vitepress/dist/assets');
      const srcIndexHtml = path.resolve(__dirname, 'dist/scaler-ui/index.html');
      const destIndexHtml = path.resolve(__dirname, '.vitepress/dist/docs/api.html');

      try {
        await copyDirectory(srcDir, destDir);
        console.log('Assets copied successfully.');
        await copyFile(srcIndexHtml, destIndexHtml);
        console.log('index.html copied successfully.');
      } catch (err) {
        console.error('Error copying assets:', err);
      }
    }
  }],
  build: {
    outDir: path.resolve(__dirname, 'dist'),
    copyPublicDir: false,
    rollupOptions: {
      input: {
        index: path.resolve(__dirname, 'scaler-ui/index.html'),
      },
    }
  },
});