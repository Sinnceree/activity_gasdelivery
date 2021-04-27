const webpack = require('webpack');
const path = require('path');
const RemovePlugin = require('remove-files-webpack-plugin');

const buildPath = path.resolve(__dirname, 'dist');

const config = {
    entry: './src/config/main.ts',
    module: {
        rules: [
            {
                test: /\.ts$/,
                use: ['ts-loader'],
                exclude: /node_modules/,
            },
        ],
    },
    plugins: [
        new RemovePlugin({
            before: {
                include: [path.resolve(buildPath, 'config')],
            },
            watch: {
                include: [path.resolve(buildPath, 'config')],
            },
        }),
    ],
    optimization: {
        minimize: true,
    },
    resolve: {
        extensions: ['.ts', '.js'],
    },
    output: {
        filename: '[contenthash].config.js',
        path: path.resolve(buildPath, 'config'),
    },
};

const server = {
    entry: './src/server/server.ts',
    module: {
        rules: [
            {
                test: /\.ts$/,
                use: ['ts-loader'],
                exclude: /node_modules/,
            },
        ],
    },
    plugins: [
        new webpack.DefinePlugin({ 'global.GENTLY': false }),
        new RemovePlugin({
            before: {
                include: [path.resolve(buildPath, 'server')],
            },
            watch: {
                include: [path.resolve(buildPath, 'server')],
            },
        }),
    ],
    optimization: {
        minimize: true,
    },
    resolve: {
        extensions: ['.ts', '.js'],
    },
    output: {
        filename: '[contenthash].server.js',
        path: path.resolve(buildPath, 'server'),
    },
    target: 'node',
};

const client = {
    entry: './src/client/client.ts',
    module: {
        rules: [
            {
                test: /\.ts$/,
                use: ['ts-loader'],
                exclude: /node_modules/,
            },
        ],
    },
    plugins: [
        new RemovePlugin({
            before: {
                include: [path.resolve(buildPath, 'client')],
            },
            watch: {
                include: [path.resolve(buildPath, 'client')],
            },
        }),
    ],
    optimization: {
        minimize: true,
    },
    resolve: {
        extensions: ['.ts', '.js'],
    },
    output: {
        filename: '[contenthash].client.js',
        path: path.resolve(buildPath, 'client'),
    },
};

module.exports = [server, client, config];
