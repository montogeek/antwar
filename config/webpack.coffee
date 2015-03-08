path = require 'path'

ExtractTextPlugin = require 'extract-text-webpack-plugin'

getCommon = require('./common')

ReactHotLoaderMatches = /View.coffee|Pages\//


exports.dev = (config) ->
  return new Promise((resolve, reject) ->
    getCommon(config).then((common) ->
      resolve({
        cache: true
        node: __filename: true
        output:
          path: path.join process.cwd(), './.antwar/build/'
          publicPath: '/'
          filename: '[name]-bundle.js'
          chunkFilename: '[chunkhash].js'
        plugins: []
        module: loaders: [
            test: /\.woff$/
            loader: 'url-loader?prefix=font/&limit=5000&mimetype=application/font-woff'
          ,
            test: /\.ttf$|\.eot$/
            loader: 'file-loader?prefix=font/'
          ,
            test: /\.coffee$/
            exclude: ReactHotLoaderMatches
            loader: 'react-hot!jshint-loader!coffee-loader'
          ,
            test: /\.json$/
            loader: 'json-loader'
          ,
            test: /\.svg$/
            loader: 'raw-loader'
          ,
            test: /\.jsx?$/
            loader: 'jsx-loader?harmony'
          ,
            test: /\.css$/
            loaders: [
              'style-loader'
              'css-loader'
            ]
          ,
            test: /\.scss$/
            loaders: [
              'style-loader'
              'css-loader'
              'autoprefixer-loader?{browsers:["last 2 version", "ie 10", "Android 4"]}'
              'sass-loader'
            ]
          ,
            test: ReactHotLoaderMatches
            loader: 'react-hot!coffee-loader'
          ,
            test: /\.md$/
            loader: 'json!yaml-frontmatter-loader'
        ]
        resolve: common.resolve
        resolveLoader: common.resolveLoader
        jshint: common.jshint
      })
    ).catch((err) ->
      reject(err)
    )
  )

exports.build = (config) ->
  return new Promise((resolve, reject) ->
    getCommon(config).then((common) ->
      resolve({
        name: 'server'
        target: 'node'
        context: path.join __dirname, '..', './'
        entry:
          bundlePage: './dev/page.coffee'
          bundleStaticRss: './dev/staticRss.coffee'
          bundleStaticPage: './dev/staticPage.coffee'
          paths: './dev/exportPaths.coffee'
        output:
          path: path.join process.cwd(), './.antwar/build'
          filename: '[name].js'
          publicPath: path.join process.cwd(), './.antwar/build'
          libraryTarget: 'commonjs2'
        plugins: [ new ExtractTextPlugin('main.css', allChunks: true) ]
        resolve: common.resolve
        resolveLoader: common.resolveLoader
        module: loaders: [
            test: /\.scss$/
            loader: ExtractTextPlugin.extract('style-loader', 'css-loader!autoprefixer-loader?{browsers:["last 2 version", "ie 10", "Android 4"]}!sass-loader')
          ,
            test: /\.jsx?$/
            loader: 'jsx-loader?harmony'
          ,
            test: /\.coffee$/
            loader: 'coffee-loader'
          ,
            test: /\.html$/
            loader: 'raw'
          ,
            test: /\.md$/
            loader: 'json!yaml-frontmatter-loader'
        ]
        jshint: common.jshint
      })
    ).catch((err) ->
      reject(err)
    )
  )